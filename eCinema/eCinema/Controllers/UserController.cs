using eCinema.Core.DTOs;
using eCinema.Core.Exceptions;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    [Authorize(Roles = "User,Administrator")]
    public class UserController : BaseController<UserDTO, UserUpsertDTO, UserSearchObject, IUserService>
    {
        public UserController(IUserService service, ILogger<UserController> logger) : base(service, logger) { }

        [AllowAnonymous]
        public override async Task<IActionResult> Post([FromBody] UserUpsertDTO upsertDTO)
        {
            return await base.Post(upsertDTO);
        }

        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> GetAll()
        {
            return await base.GetAll();
        }

        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> GetPaged([FromQuery] UserSearchObject searchObject)
        {
            return await base.GetPaged(searchObject);
        }

        [HttpPut]
        public async Task<IActionResult> ChangePassword([FromBody] UserNewPasswordDTO dto)
        {
            try
            {
                await service.ChangePassword(dto);
                return Ok();
            }
            catch (UserWrongCredentialsException e)
            {
                logger.LogError(e, $"Error while changing password for object with ID {dto.ID}", dto.ID);
                return Unauthorized(new { message = e.Message });
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while changing password for object with ID {dto.ID}", dto.ID);
                return BadRequest();
            }
        }
        [HttpPut]
        public async Task<IActionResult> UpdateProfileImage([FromBody] UserUpsertImageDTO dto)
        {
            try
            {
                var user = await service.UpdateProfileImageAsync(dto);
                return Ok(user);
            }
            catch (UserNotFoundException e)
            {
                logger.LogError(e, $"Error while updating image for object with ID {dto.ID}", dto.ID);
                return Unauthorized(new { message = e.Message });
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while updating image for object with ID {dto.ID}", dto.ID);
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

        [HttpPut]
        [AllowAnonymous]
        public async Task<IActionResult> Verify([FromBody] VerificationDTO dto)
        {
            try
            {
                await service.Verify(dto);
                return Ok();
            }
            catch (UserNotFoundException e)
            {
                logger.LogError(e, $"Error while verifying email {dto.Email}");
                return Unauthorized(new { message = e.Message });
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while verifying email {dto.Email}");
                return BadRequest();
            }
        }
    }
}
