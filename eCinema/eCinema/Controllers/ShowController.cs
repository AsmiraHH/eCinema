using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class ShowController : BaseController<ShowDTO, ShowUpsertDTO, ShowSearchObject, IShowService>
    {
        public ShowController(IShowService service) : base(service) { }
    }
}
