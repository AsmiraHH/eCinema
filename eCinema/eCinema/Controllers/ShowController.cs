using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class ShowController : BaseController<ShowDTO, ShowUpsertDTO, ShowSearchObject, IShowService>
    {
        public ShowController(IShowService service, ILogger<ShowController> logger) : base(service, logger) { }
       
        [HttpGet("{movieId}/{cinemaId}/{isDistinct}")]
        public virtual async Task<IActionResult> GetByMovieId(int movieId, int cinemaId, bool isDistinct)
        {
            try
            {
                var dto = await service.GetByMovieIdAsync(movieId, cinemaId, isDistinct);
                return Ok(dto);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while getting recommended shows.");
                return BadRequest();
            }
        }
    }
}
