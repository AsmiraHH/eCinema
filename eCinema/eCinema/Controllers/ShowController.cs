using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class ShowController : BaseController<ShowDTO, ShowUpsertDTO, ShowSearchObject, IShowService>
    {
        public ShowController(IShowService service, ILogger<ShowController> logger) : base(service, logger) { }

        [HttpGet]
        public virtual async Task<IActionResult> GetLastAdded()
        {
            try
            {
                var dto = await service.GetLastAddedAsync();
                return Ok(dto);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while getting last added shows.");
                return BadRequest();
            }
        }
        [HttpGet]
        public virtual async Task<IActionResult> GetMostWatched()
        {
            try
            {
                var dto = await service.GetMostWatchedAsync();
                return Ok(dto);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while getting most watched shows.");
                return BadRequest();
            }
        }
    }
}
