using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    [Authorize(Roles = "Administrator,User")]
    public class ReservationController : BaseController<ReservationDTO, ReservationUpsertDTO, ReservationSearchObject, IReservationService>
    {
        public ReservationController(IReservationService service, ILogger<ReservationController> logger) : base(service, logger) { }

        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> GetAll()
        {
           return await base.GetAll(); 
        }

        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> GetPaged([FromQuery] ReservationSearchObject searchObject)
        {
           return await base.GetPaged(searchObject);
        }

        [HttpGet("{userID}")]
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
        [Authorize(Roles = "Administrator")]
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
