using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class EmployeeController : BaseController<EmployeeDTO, EmployeeUpsertDTO, EmployeeSearchObject, IEmployeeService>
    {
        public EmployeeController(IEmployeeService service, ILogger<EmployeeController> logger) : base(service, logger) { }

        [HttpPut]
        public async Task<IActionResult> ChangePassword([FromBody] EmployeeNewPasswordDTO dto)
        {
            try
            {
                await service.ChangePassword(dto);
                return Ok();
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while changing password for object with ID {dto.ID}", dto.ID);
                return BadRequest();
            }
        }
    }
}
