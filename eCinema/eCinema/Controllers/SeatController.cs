using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class SeatController : BaseController<SeatDTO, SeatUpsertDTO, BaseSearchObject, ISeatService>
    {
        public SeatController(ISeatService service) : base(service) { }
    }
}
