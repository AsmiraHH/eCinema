using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class ShowController : BaseController<ShowDTO, ShowUpsertDTO, ShowSearchObject, IShowService>
    {
        public ShowController(IShowService service, ILogger<ShowController> logger) : base(service, logger) { }
       
        [HttpGet("{cinemaId}/{userId}")]
        public virtual async Task<IActionResult> GetRecommended(int cinemaId, int userId)
        {
            try
            {
                var dto = await service.GetRecommendedAsync(cinemaId, userId);
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
