using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class ReservationController : BaseController<ReservationDTO, ReservationUpsertDTO, ReservationSearchObject, IReservationService>
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
        [HttpGet]
        public virtual async Task<IActionResult> GetForReport([FromQuery] ReportDTO reportDTO)
        {
            try
            {
                var dto = await service.GetForReportAsync(reportDTO);
                return Ok(dto);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while getting report object");
                return BadRequest();
            }
        }
    }
}
