using QuranApp.Domain.Common;

namespace QuranApp.Domain.Entities;

public class UserStatistics : BaseEntity
{
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;
    public int TotalPagesRead { get; set; }
    public int TotalAyahsRead { get; set; }
    public int TotalReadingMinutes { get; set; }
    public int LongestStreak { get; set; }
    public int CurrentStreak { get; set; }
    public int HatimsCompleted { get; set; }
    public DateTime? LastReadingDate { get; set; }
}