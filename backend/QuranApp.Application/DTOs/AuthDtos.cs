namespace QuranApp.Application.DTOs;

public record LoginRequest(string Email, string Password);
public record RegisterRequest(string Name, string Email, string Password);
public record AuthResponse(string Token, string RefreshToken, UserDto User);
public record RefreshTokenRequest(string RefreshToken);

public record UserDto(
    Guid Id,
    string Name,
    string Email,
    bool IsEmailVerified,
    string? AvatarUrl,
    DateTime CreatedAt
);