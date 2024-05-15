using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace eCinema.Controllers
{
    public class UserController : BaseController<UserDTO, UserUpsertDTO, UserSearchObject, IUserService>
    {
        public UserController(IUserService service, ILogger<UserController> logger) : base(service, logger) { }

        [HttpPut]
        public async Task<IActionResult> ChangePassword([FromBody] UserNewPasswordDTO dto)
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
        [HttpGet("{username}")]
        public virtual async Task<IActionResult> GetRoles(string username)
        {
            try
            {
                var roles = await service.GetRoles(username);
                return Ok(roles);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while getting role of object with username {username}", username);
                return BadRequest();
            }
        }
        [HttpGet("{username}/{password}")]
        public virtual async Task<IActionResult> Login(string username, string password)
        {
            try
            {
                var dto = await service.Login(username, password);
                return Ok(dto);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while login with username {username} and password {password}", username, password);
                return BadRequest();
            }
        }
    }
}
