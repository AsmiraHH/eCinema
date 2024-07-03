using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;

namespace eCinema.Controllers
{
    [Authorize(Roles = "Administrator")]
    public class ActorController : BaseController<ActorDTO, ActorUpsertDTO, ActorSearchObject, IActorService>
    {
        public ActorController(IActorService service, ILogger<ActorController> logger) : base(service, logger) { }
    }
}
