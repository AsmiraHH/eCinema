using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class MovieController : BaseController<MovieDTO, MovieUpsertDTO, MovieSearchObject, IMovieService>
    {
        public MovieController(IMovieService service, ILogger<MovieController> logger) : base(service, logger) { }
        
        [HttpGet("{cinemaId}")]
        public virtual async Task<IActionResult> GetLastAdded(int cinemaId)
        {
            try
            {
                var dto = await service.GetLastAddedAsync(cinemaId);
                return Ok(dto);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while getting last added movies.");
                return BadRequest();
            }
        }
        [HttpGet("{cinemaId}")]
        public virtual async Task<IActionResult> GetMostWatched(int cinemaId)
        {
            try
            {
                var dto = await service.GetMostWatchedAsync(cinemaId);
                return Ok(dto);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while getting most watched movies.");
                return BadRequest();
            }
        }
    }
}
