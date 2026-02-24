using QuranApp.Application.DTOs;

namespace QuranApp.Application.Interfaces;

public interface IReadingService
{
    Task<List<ReadingGoalDto>> GetGoalsAsync(Guid userId);
    Task<ReadingGoalDto?> GetActiveGoalAsync(Guid userId);
    Task<ReadingGoalDto> CreateGoalAsync(Guid userId, CreateGoalRequest request);
    Task<ReadingGoalDto> UpdateGoalAsync(Guid userId, Guid goalId, UpdateGoalRequest request);
    Task DeleteGoalAsync(Guid userId, Guid goalId);
    Task<List<ReadingSessionDto>> GetSessionsAsync(Guid userId, Guid goalId);
    Task<ReadingSessionDto> LogSessionAsync(Guid userId, LogSessionRequest request);
    Task<List<BookmarkDto>> GetBookmarksAsync(Guid userId);
    Task<BookmarkDto> AddBookmarkAsync(Guid userId, CreateBookmarkRequest request);
    Task DeleteBookmarkAsync(Guid userId, Guid bookmarkId);
    Task<SyncResponse> SyncAsync(Guid userId, SyncRequest request);
}