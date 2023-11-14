using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class EmployeeController : BaseController<EmployeeDTO, EmployeeUpsertDTO, BaseSearchObject, IEmployeeService>
    {
        public EmployeeController(IEmployeeService service) : base(service) { }

        [HttpPut]
        public async Task<IActionResult> ChangePassword([FromBody] EmployeeNewPasswordDTO dto)
        {
            try
            {
                await service.ChangePassword(dto);
                return Ok();
            }
            catch (Exception)
            {
                return BadRequest();
            }
        }
    }
}
