using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    [Authorize(Roles = "Administrator,Editor,User")]
    public class MovieController : BaseController<MovieDTO, MovieUpsertDTO, MovieSearchObject, IMovieService>
    {
        public MovieController(IMovieService service, ILogger<MovieController> logger) : base(service, logger) { }

        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> Post([FromBody] MovieUpsertDTO upsertDTO)
        {
           return await base.Post(upsertDTO); 
        }

        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> Put([FromBody] MovieUpsertDTO upsertDTO)
        {
            return await base.Put(upsertDTO);
        }

        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> Delete(int id)
        {
            return await base.Delete(id);
        }

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

        [HttpGet("{cinemaId}/{userId}")]
        public IActionResult GetRecommended(int cinemaId, int userId)
        {
            try
            {
                var dto = service.GetRecommended(cinemaId, userId);
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
