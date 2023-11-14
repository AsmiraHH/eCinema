using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class ReservationController : BaseController<ReservationDTO, ReservationUpsertDTO, BaseSearchObject, IReservationService>
    {
        public ReservationController(IReservationService service) : base(service) { }
    }
}
