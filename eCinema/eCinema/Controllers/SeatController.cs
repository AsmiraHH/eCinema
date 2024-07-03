using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class SeatController : BaseController<SeatDTO, SeatUpsertDTO, BaseSearchObject, ISeatService>
    {
        public SeatController(ISeatService service, ILogger<SeatController> logger) : base(service, logger) { }

        [HttpPost]
        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> Post([FromBody] SeatUpsertDTO upsertDTO)
        {
            try
            {
                var dto = await service.AddByRowColumnAsync(upsertDTO);
                return Ok(dto);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while posting an object");
                return BadRequest(e);
            }
        }

        [HttpPut]
        [Authorize(Roles = "Administrator")]
        public  async Task<IActionResult> Disable([FromBody] List<SeatDisableDTO> upsertDTO)
        {
            try
            {
                var dto = await service.DisableAsync(upsertDTO);
                return Ok(dto);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while posting an object");
                return BadRequest(e);
            }
        }
        
        [HttpGet("{hallId}")]
        [Authorize(Roles = "Administrator,User")]
        public virtual async Task<IActionResult> GetByHallId(int hallId)
        {
            try
            {
                var dto = await service.GetByHallIdAsync(hallId);
                return Ok(dto);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while getting objects with Hall ID {hallId}", hallId);
                return BadRequest();
            }
        }
    }
}
