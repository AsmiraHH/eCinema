using eCinema.Core.DTOs;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class SeatController : BaseController<SeatDTO, SeatUpsertDTO, ISeatService>
    {
        public SeatController(ISeatService service) : base(service) { }
    }
}
