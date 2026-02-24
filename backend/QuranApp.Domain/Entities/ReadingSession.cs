using QuranApp.Domain.Common;

namespace QuranApp.Domain.Entities;

public class ReadingSession : BaseEntity
{
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;
    public Guid GoalId { get; set; }
    public ReadingGoal Goal { get; set; } = null!;

    public DateTime Date { get; set; }
    public int PagesRead { get; set; }
    public int AyahsRead { get; set; }
    public int StartPage { get; set; }
    public int EndPage { get; set; }
    public int DurationMinutes { get; set; }
}