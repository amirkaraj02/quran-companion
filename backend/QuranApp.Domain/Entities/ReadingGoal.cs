using QuranApp.Domain.Common;

namespace QuranApp.Domain.Entities;

public enum GoalType { Hatim, DailyReading, Memorization, Learning }

public class ReadingGoal : BaseEntity
{
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    public GoalType Type { get; set; }
    public string Title { get; set; } = string.Empty;
    public int TargetDays { get; set; }
    public int TargetPagesPerDay { get; set; }
    public int TotalPagesRead { get; set; }
    public int CurrentStreak { get; set; }
    public int LongestStreak { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime? CompletedDate { get; set; }
    public bool IsActive { get; set; } = true;
    public int ReminderHour { get; set; } = 7;
    public int ReminderMinute { get; set; } = 0;

    public ICollection<ReadingSession> Sessions { get; set; } = new List<ReadingSession>();
}