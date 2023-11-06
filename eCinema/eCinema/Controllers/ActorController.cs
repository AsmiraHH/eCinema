using eCinema.Core.DTOs;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class ActorController : BaseController<ActorDTO, ActorUpsertDTO, IActorService>
    {
        public ActorController(IActorService service) : base(service) { }
    }
}
