using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class MovieController : BaseController<MovieDTO, MovieUpsertDTO, MovieSearchObject, IMovieService>
    {
        public MovieController(IMovieService service, ILogger<MovieController> logger) : base(service, logger) { }

        [HttpPost]
        public override async Task<IActionResult> Post([FromBody] MovieUpsertDTO upsertDTO)
        {
            try
            {
                var dto = await service.AddAsync(upsertDTO);
                return Ok(dto);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while posting an object");
                return BadRequest(e);
            }
        }
    }
}
