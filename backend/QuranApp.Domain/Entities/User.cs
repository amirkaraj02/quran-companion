using QuranApp.Domain.Common;

namespace QuranApp.Domain.Entities;

public class User : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public string? RefreshToken { get; set; }
    public DateTime? RefreshTokenExpiry { get; set; }
    public bool IsEmailVerified { get; set; }
    public string? AvatarUrl { get; set; }

    public ICollection<ReadingGoal> ReadingGoals { get; set; } = new List<ReadingGoal>();
    public ICollection<ReadingSession> ReadingSessions { get; set; } = new List<ReadingSession>();
    public ICollection<Bookmark> Bookmarks { get; set; } = new List<Bookmark>();
    public ICollection<Highlight> Highlights { get; set; } = new List<Highlight>();
    public PrayerSettings? PrayerSettings { get; set; }
}