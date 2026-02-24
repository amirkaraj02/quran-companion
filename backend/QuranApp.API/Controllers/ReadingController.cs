using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using QuranApp.Application.DTOs;
using QuranApp.Application.Interfaces;

namespace QuranApp.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ReadingController : ControllerBase
{
    private readonly IReadingService _readingService;

    public ReadingController(IReadingService readingService) =>
        _readingService = readingService;

    private Guid UserId => Guid.Parse(
        User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    [HttpGet("goals")]
    public async Task<IActionResult> GetGoals() =>
        Ok(await _readingService.GetGoalsAsync(UserId));

    [HttpGet("goals/active")]
    public async Task<IActionResult> GetActiveGoal() =>
        Ok(await _readingService.GetActiveGoalAsync(UserId));

    [HttpPost("goals")]
    public async Task<IActionResult> CreateGoal([FromBody] CreateGoalRequest request)
    {
        var goal = await _readingService.CreateGoalAsync(UserId, request);
        return Created($"/api/reading/goals/{goal.Id}", goal);
    }

    [HttpPut("goals/{id}")]
    public async Task<IActionResult> UpdateGoal(Guid id, [FromBody] UpdateGoalRequest request)
    {
        try
        {
            return Ok(await _readingService.UpdateGoalAsync(UserId, id, request));
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }

    [HttpDelete("goals/{id}")]
    public async Task<IActionResult> DeleteGoal(Guid id)
    {
        await _readingService.DeleteGoalAsync(UserId, id);
        return NoContent();
    }

    [HttpGet("goals/{goalId}/sessions")]
    public async Task<IActionResult> GetSessions(Guid goalId) =>
        Ok(await _readingService.GetSessionsAsync(UserId, goalId));

    [HttpPost("sessions")]
    public async Task<IActionResult> LogSession([FromBody] LogSessionRequest request) =>
        Ok(await _readingService.LogSessionAsync(UserId, request));

    [HttpGet("bookmarks")]
    public async Task<IActionResult> GetBookmarks() =>
        Ok(await _readingService.GetBookmarksAsync(UserId));

    [HttpPost("bookmarks")]
    public async Task<IActionResult> AddBookmark([FromBody] CreateBookmarkRequest request) =>
        Ok(await _readingService.AddBookmarkAsync(UserId, request));

    [HttpDelete("bookmarks/{id}")]
    public async Task<IActionResult> DeleteBookmark(Guid id)
    {
        await _readingService.DeleteBookmarkAsync(UserId, id);
        return NoContent();
    }

    [HttpPost("sync")]
    public async Task<IActionResult> Sync([FromBody] SyncRequest request) =>
        Ok(await _readingService.SyncAsync(UserId, request));
}