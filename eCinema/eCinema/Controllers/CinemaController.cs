using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    [Authorize(Roles = "Administrator, User")]
    public class CinemaController : BaseController<CinemaDTO, CinemaUpsertDTO, CinemaSearchObject, ICinemaService>
    {
        public CinemaController(ICinemaService service, ILogger<CinemaController> logger) : base(service, logger) { }

        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> Post([FromBody] CinemaUpsertDTO upsertDTO)
        {
            return await base.Post(upsertDTO);
        }

        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> Put([FromBody] CinemaUpsertDTO upsertDTO)
        {
            return await base.Put(upsertDTO);
        }

        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> Delete(int id)
        {
            return await base.Delete(id);
        }
    }
}
