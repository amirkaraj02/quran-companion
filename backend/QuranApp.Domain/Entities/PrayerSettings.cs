using QuranApp.Domain.Common;

namespace QuranApp.Domain.Entities;

public class PrayerSettings : BaseEntity
{
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;
    public double Latitude { get; set; } = 41.3275;
    public double Longitude { get; set; } = 19.8187;
    public string CityName { get; set; } = "Tirana";
    public string CalculationMethod { get; set; } = "Diyanet";
    public bool FajrNotification { get; set; } = true;
    public bool DhuhrNotification { get; set; } = true;
    public bool AsrNotification { get; set; } = true;
    public bool MaghribNotification { get; set; } = true;
    public bool IshaNotification { get; set; } = true;
}