using QuranApp.Domain.Common;

namespace QuranApp.Domain.Entities;

public class Highlight : BaseEntity
{
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;
    public int SurahNumber { get; set; }
    public int AyahNumber { get; set; }
    public string ColorHex { get; set; } = "#FFFF00";
}