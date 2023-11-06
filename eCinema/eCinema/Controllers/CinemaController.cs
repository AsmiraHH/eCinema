using eCinema.Core.DTOs;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class CinemaController : BaseController<CinemaDTO, CinemaUpsertDTO, ICinemaService>
    {
        public CinemaController(ICinemaService service) : base(service) { }
    }
}
