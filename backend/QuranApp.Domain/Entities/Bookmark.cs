using QuranApp.Domain.Common;

namespace QuranApp.Domain.Entities;

public class Bookmark : BaseEntity
{
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;
    public int SurahNumber { get; set; }
    public int AyahNumber { get; set; }
    public int PageNumber { get; set; }
    public string? Note { get; set; }
}