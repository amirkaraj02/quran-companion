using QuranApp.Domain.Entities;

namespace QuranApp.Application.Interfaces;

public interface IJwtService
{
    string GenerateAccessToken(User user);
    string GenerateRefreshToken();
    Guid? ValidateToken(string token);
}