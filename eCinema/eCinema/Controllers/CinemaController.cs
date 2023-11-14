using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class CinemaController : BaseController<CinemaDTO, CinemaUpsertDTO, BaseSearchObject, ICinemaService>
    {
        public CinemaController(ICinemaService service) : base(service) { }
    }
}
