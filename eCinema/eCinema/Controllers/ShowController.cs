using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    [Authorize(Roles = "Administrator, User")]
    public class ShowController : BaseController<ShowDTO, ShowUpsertDTO, ShowSearchObject, IShowService>
    {
        public ShowController(IShowService service, ILogger<ShowController> logger) : base(service, logger) { }

        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> Post([FromBody] ShowUpsertDTO upsertDTO)
        {
            return await base.Post(upsertDTO);
        }

        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> Put([FromBody] ShowUpsertDTO upsertDTO)
        {
            return await base.Put(upsertDTO);
        }

        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> Delete(int id)
        {
            return await base.Delete(id);
        }

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
