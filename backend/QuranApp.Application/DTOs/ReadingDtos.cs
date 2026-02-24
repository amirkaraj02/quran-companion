namespace QuranApp.Application.DTOs;

public record ReadingGoalDto(
    Guid Id,
    int Type,
    string Title,
    int TargetDays,
    int TargetPagesPerDay,
    int TotalPagesRead,
    int CurrentStreak,
    int LongestStreak,
    DateTime StartDate,
    DateTime? CompletedDate,
    bool IsActive,
    int ReminderHour,
    int ReminderMinute
);

public record CreateGoalRequest(
    int Type,
    string Title,
    int TargetDays,
    int TargetPagesPerDay,
    int ReminderHour,
    int ReminderMinute
);

public record UpdateGoalRequest(
    int TotalPagesRead,
    int CurrentStreak,
    int LongestStreak
);

public record ReadingSessionDto(
    Guid Id,
    Guid GoalId,
    DateTime Date,
    int PagesRead,
    int AyahsRead,
    int StartPage,
    int EndPage,
    int DurationMinutes
);

public record LogSessionRequest(
    Guid GoalId,
    DateTime Date,
    int PagesRead,
    int AyahsRead,
    int StartPage,
    int EndPage,
    int DurationMinutes
);

public record BookmarkDto(
    Guid Id,
    int SurahNumber,
    int AyahNumber,
    int PageNumber,
    string? Note,
    DateTime CreatedAt
);

public record CreateBookmarkRequest(
    int SurahNumber,
    int AyahNumber,
    int PageNumber,
    string? Note
);

public record SyncRequest(
    List<BookmarkDto> Bookmarks,
    List<ReadingSessionDto> Sessions,
    ReadingGoalDto? ActiveGoal
);

public record SyncResponse(
    List<BookmarkDto> Bookmarks,
    List<ReadingSessionDto> Sessions,
    ReadingGoalDto? ActiveGoal,
    DateTime SyncedAt
);