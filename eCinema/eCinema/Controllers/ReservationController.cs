using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class ReservationController : BaseController<ReservationDTO, ReservationUpsertDTO, BaseSearchObject, IReservationService>
    {
        public ReservationController(IReservationService service, ILogger<ReservationController> logger) : base(service, logger) { }

        [HttpGet("userID")]
        public virtual async Task<IActionResult> GetByUserID(int userID)
        {
            try
            {
                var dtos = await service.GetByUserID(userID);
                return Ok(dtos);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while getting reservations of user with ID {userID}", userID);
                return BadRequest();
            }
        }
    }
}
