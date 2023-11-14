using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class ActorController : BaseController<ActorDTO, ActorUpsertDTO, BaseSearchObject, IActorService>
    {
        public ActorController(IActorService service) : base(service) { }
    }
}
