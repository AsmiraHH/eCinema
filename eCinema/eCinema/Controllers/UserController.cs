using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class UserController : BaseController<UserDTO, UserUpsertDTO, BaseSearchObject, IUserService>
    {
        public UserController(IUserService service) : base(service) { }

        [HttpPut]
        public async Task<IActionResult> ChangePassword([FromBody] UserNewPasswordDTO dto)
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
