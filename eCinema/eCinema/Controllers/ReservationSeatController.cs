using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class ReservationSeatController : BaseController<ReservationSeatDTO, ReservationSeatUpsertDTO, BaseSearchObject, IReservationSeatService>
    {
        public ReservationSeatController(IReservationSeatService service, ILogger<ReservationSeatController> logger) : base(service, logger) { }

        
        [HttpGet("{showId}")]
        public virtual async Task<IActionResult> GetByShowId(int showId)
        {
            try
            {
                var dto = await service.GetByShowIdAsync(showId);
                return Ok(dto);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while getting objects with Show ID {showId}", showId);
                return BadRequest();
            }
        }
    }
}
