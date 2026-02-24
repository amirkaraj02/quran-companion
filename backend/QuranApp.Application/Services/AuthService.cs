using System.Security.Cryptography;
using System.Text;
using Microsoft.EntityFrameworkCore;
using QuranApp.Application.DTOs;
using QuranApp.Application.Interfaces;
using QuranApp.Domain.Entities;
using QuranApp.Infrastructure.Data;

namespace QuranApp.Application.Services;

public class AuthService : IAuthService
{
    private readonly AppDbContext _db;
    private readonly IJwtService _jwt;

    public AuthService(AppDbContext db, IJwtService jwt)
    {
        _db = db;
        _jwt = jwt;
    }

    public async Task<AuthResponse> LoginAsync(LoginRequest request)
    {
        var user = await _db.Users.FirstOrDefaultAsync(u => u.Email == request.Email.ToLower())
            ?? throw new UnauthorizedAccessException("Invalid credentials");

        if (!VerifyPassword(request.Password, user.PasswordHash))
            throw new UnauthorizedAccessException("Invalid credentials");

        return await GenerateAuthResponse(user);
    }

    public async Task<AuthResponse> RegisterAsync(RegisterRequest request)
    {
        if (await _db.Users.AnyAsync(u => u.Email == request.Email.ToLower()))
            throw new InvalidOperationException("Email already registered");

        var user = new User
        {
            Name = request.Name,
            Email = request.Email.ToLower(),
            PasswordHash = HashPassword(request.Password),
        };

        _db.Users.Add(user);
        await _db.SaveChangesAsync();

        return await GenerateAuthResponse(user);
    }

    public async Task<AuthResponse> RefreshTokenAsync(string refreshToken)
    {
        var user = await _db.Users.FirstOrDefaultAsync(u =>
            u.RefreshToken == refreshToken &&
            u.RefreshTokenExpiry > DateTime.UtcNow)
            ?? throw new UnauthorizedAccessException("Invalid refresh token");

        return await GenerateAuthResponse(user);
    }

    public async Task RevokeTokenAsync(Guid userId)
    {
        var user = await _db.Users.FindAsync(userId);
        if (user != null)
        {
            user.RefreshToken = null;
            user.RefreshTokenExpiry = null;
            await _db.SaveChangesAsync();
        }
    }

    private async Task<AuthResponse> GenerateAuthResponse(User user)
    {
        var accessToken = _jwt.GenerateAccessToken(user);
        var refreshToken = _jwt.GenerateRefreshToken();

        user.RefreshToken = refreshToken;
        user.RefreshTokenExpiry = DateTime.UtcNow.AddDays(30);
        user.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();

        return new AuthResponse(
            Token: accessToken,
            RefreshToken: refreshToken,
            User: MapToDto(user)
        );
    }

    private static UserDto MapToDto(User u) => new(
        u.Id, u.Name, u.Email, u.IsEmailVerified, u.AvatarUrl, u.CreatedAt);

    private static string HashPassword(string password)
    {
        using var sha256 = SHA256.Create();
        var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password + "QuranAppSalt2024"));
        return Convert.ToBase64String(bytes);
    }

    private static bool VerifyPassword(string password, string hash) =>
        HashPassword(password) == hash;
}