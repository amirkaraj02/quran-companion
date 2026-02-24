using Microsoft.EntityFrameworkCore;
using QuranApp.Application.DTOs;
using QuranApp.Application.Interfaces;
using QuranApp.Domain.Entities;
using QuranApp.Infrastructure.Data;

namespace QuranApp.Application.Services;

public class ReadingService : IReadingService
{
    private readonly AppDbContext _db;

    public ReadingService(AppDbContext db) => _db = db;

    public async Task<List<ReadingGoalDto>> GetGoalsAsync(Guid userId)
    {
        var goals = await _db.ReadingGoals
            .Where(g => g.UserId == userId)
            .OrderByDescending(g => g.CreatedAt)
            .ToListAsync();
        return goals.Select(MapGoalToDto).ToList();
    }

    public async Task<ReadingGoalDto?> GetActiveGoalAsync(Guid userId)
    {
        var goal = await _db.ReadingGoals
            .FirstOrDefaultAsync(g => g.UserId == userId && g.IsActive);
        return goal != null ? MapGoalToDto(goal) : null;
    }

    public async Task<ReadingGoalDto> CreateGoalAsync(Guid userId, CreateGoalRequest request)
    {
        // Deactivate existing active goals
        await _db.ReadingGoals
            .Where(g => g.UserId == userId && g.IsActive)
            .ExecuteUpdateAsync(s => s.SetProperty(g => g.IsActive, false));

        var goal = new ReadingGoal
        {
            UserId = userId,
            Type = (GoalType)request.Type,
            Title = request.Title,
            TargetDays = request.TargetDays,
            TargetPagesPerDay = request.TargetPagesPerDay,
            StartDate = DateTime.UtcNow,
            ReminderHour = request.ReminderHour,
            ReminderMinute = request.ReminderMinute,
        };

        _db.ReadingGoals.Add(goal);
        await _db.SaveChangesAsync();
        return MapGoalToDto(goal);
    }

    public async Task<ReadingGoalDto> UpdateGoalAsync(Guid userId, Guid goalId, UpdateGoalRequest request)
    {
        var goal = await _db.ReadingGoals
            .FirstOrDefaultAsync(g => g.Id == goalId && g.UserId == userId)
            ?? throw new KeyNotFoundException("Goal not found");

        goal.TotalPagesRead = request.TotalPagesRead;
        goal.CurrentStreak = request.CurrentStreak;
        goal.LongestStreak = Math.Max(goal.LongestStreak, request.LongestStreak);
        goal.UpdatedAt = DateTime.UtcNow;

        // Check completion (604 pages = full Quran)
        if (goal.TotalPagesRead >= 604 && goal.CompletedDate == null)
            goal.CompletedDate = DateTime.UtcNow;

        await _db.SaveChangesAsync();
        return MapGoalToDto(goal);
    }

    public async Task DeleteGoalAsync(Guid userId, Guid goalId)
    {
        await _db.ReadingGoals
            .Where(g => g.Id == goalId && g.UserId == userId)
            .ExecuteDeleteAsync();
    }

    public async Task<List<ReadingSessionDto>> GetSessionsAsync(Guid userId, Guid goalId)
    {
        var sessions = await _db.ReadingSessions
            .Where(s => s.UserId == userId && s.GoalId == goalId)
            .OrderByDescending(s => s.Date)
            .Take(100)
            .ToListAsync();
        return sessions.Select(MapSessionToDto).ToList();
    }

    public async Task<ReadingSessionDto> LogSessionAsync(Guid userId, LogSessionRequest request)
    {
        var session = new ReadingSession
        {
            UserId = userId,
            GoalId = request.GoalId,
            Date = request.Date,
            PagesRead = request.PagesRead,
            AyahsRead = request.AyahsRead,
            StartPage = request.StartPage,
            EndPage = request.EndPage,
            DurationMinutes = request.DurationMinutes,
        };

        _db.ReadingSessions.Add(session);

        // Update goal progress
        var goal = await _db.ReadingGoals
            .FirstOrDefaultAsync(g => g.Id == request.GoalId && g.UserId == userId);
        if (goal != null)
        {
            goal.TotalPagesRead += request.PagesRead;
            goal.UpdatedAt = DateTime.UtcNow;
        }

        await _db.SaveChangesAsync();
        return MapSessionToDto(session);
    }

    public async Task<List<BookmarkDto>> GetBookmarksAsync(Guid userId)
    {
        var bookmarks = await _db.Bookmarks
            .Where(b => b.UserId == userId)
            .OrderByDescending(b => b.CreatedAt)
            .ToListAsync();
        return bookmarks.Select(MapBookmarkToDto).ToList();
    }

    public async Task<BookmarkDto> AddBookmarkAsync(Guid userId, CreateBookmarkRequest request)
    {
        var bookmark = new Bookmark
        {
            UserId = userId,
            SurahNumber = request.SurahNumber,
            AyahNumber = request.AyahNumber,
            PageNumber = request.PageNumber,
            Note = request.Note,
        };

        _db.Bookmarks.Add(bookmark);
        await _db.SaveChangesAsync();
        return MapBookmarkToDto(bookmark);
    }

    public async Task DeleteBookmarkAsync(Guid userId, Guid bookmarkId)
    {
        await _db.Bookmarks
            .Where(b => b.Id == bookmarkId && b.UserId == userId)
            .ExecuteDeleteAsync();
    }

    public async Task<SyncResponse> SyncAsync(Guid userId, SyncRequest request)
    {
        // Merge bookmarks
        foreach (var b in request.Bookmarks)
        {
            var exists = await _db.Bookmarks.AnyAsync(x => x.Id == b.Id);
            if (!exists)
            {
                _db.Bookmarks.Add(new Bookmark
                {
                    Id = b.Id,
                    UserId = userId,
                    SurahNumber = b.SurahNumber,
                    AyahNumber = b.AyahNumber,
                    PageNumber = b.PageNumber,
                    Note = b.Note,
                    CreatedAt = b.CreatedAt,
                });
            }
        }

        // Merge sessions
        foreach (var s in request.Sessions)
        {
            var exists = await _db.ReadingSessions.AnyAsync(x => x.Id == s.Id);
            if (!exists)
            {
                _db.ReadingSessions.Add(new ReadingSession
                {
                    Id = s.Id,
                    UserId = userId,
                    GoalId = s.GoalId,
                    Date = s.Date,
                    PagesRead = s.PagesRead,
                    AyahsRead = s.AyahsRead,
                    StartPage = s.StartPage,
                    EndPage = s.EndPage,
                    DurationMinutes = s.DurationMinutes,
                });
            }
        }

        await _db.SaveChangesAsync();

        return new SyncResponse(
            Bookmarks: await GetBookmarksAsync(userId),
            Sessions: new List<ReadingSessionDto>(),
            ActiveGoal: await GetActiveGoalAsync(userId),
            SyncedAt: DateTime.UtcNow
        );
    }

    private static ReadingGoalDto MapGoalToDto(ReadingGoal g) => new(
        g.Id, (int)g.Type, g.Title, g.TargetDays, g.TargetPagesPerDay,
        g.TotalPagesRead, g.CurrentStreak, g.LongestStreak, g.StartDate,
        g.CompletedDate, g.IsActive, g.ReminderHour, g.ReminderMinute);

    private static ReadingSessionDto MapSessionToDto(ReadingSession s) => new(
        s.Id, s.GoalId, s.Date, s.PagesRead, s.AyahsRead,
        s.StartPage, s.EndPage, s.DurationMinutes);

    private static BookmarkDto MapBookmarkToDto(Bookmark b) => new(
        b.Id, b.SurahNumber, b.AyahNumber, b.PageNumber, b.Note, b.CreatedAt);
}