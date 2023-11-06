using eCinema.Core.DTOs;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class UserController : BaseController<UserDTO, UserUpsertDTO, IUserService>
    {
        public UserController(IUserService service) : base(service) { }
    }
}
