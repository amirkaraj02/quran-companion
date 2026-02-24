using Microsoft.EntityFrameworkCore;
using QuranApp.Domain.Entities;

namespace QuranApp.Infrastructure.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<User> Users => Set<User>();
    public DbSet<ReadingGoal> ReadingGoals => Set<ReadingGoal>();
    public DbSet<ReadingSession> ReadingSessions => Set<ReadingSession>();
    public DbSet<Bookmark> Bookmarks => Set<Bookmark>();
    public DbSet<Highlight> Highlights => Set<Highlight>();
    public DbSet<PrayerSettings> PrayerSettings => Set<PrayerSettings>();
    public DbSet<UserStatistics> UserStatistics => Set<UserStatistics>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<User>(e => {
            e.HasIndex(u => u.Email).IsUnique();
            e.Property(u => u.Email).IsRequired().HasMaxLength(256);
            e.Property(u => u.Name).IsRequired().HasMaxLength(128);
        });

        modelBuilder.Entity<ReadingGoal>(e => {
            e.HasOne(g => g.User).WithMany(u => u.ReadingGoals)
                .HasForeignKey(g => g.UserId).OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<ReadingSession>(e => {
            e.HasOne(s => s.User).WithMany(u => u.ReadingSessions)
                .HasForeignKey(s => s.UserId).OnDelete(DeleteBehavior.Cascade);
            e.HasOne(s => s.Goal).WithMany(g => g.Sessions)
                .HasForeignKey(s => s.GoalId).OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<Bookmark>(e => {
            e.HasOne(b => b.User).WithMany(u => u.Bookmarks)
                .HasForeignKey(b => b.UserId).OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<PrayerSettings>(e => {
            e.HasOne(p => p.User).WithOne(u => u.PrayerSettings)
                .HasForeignKey<PrayerSettings>(p => p.UserId).OnDelete(DeleteBehavior.Cascade);
        });
    }
}