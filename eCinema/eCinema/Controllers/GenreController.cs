using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    [Authorize(Roles = "Administrator, User")]
    public class GenreController : BaseController<GenreDTO, GenreUpsertDTO, GenreSearchObject, IGenreService>
    {
        public GenreController(IGenreService service, ILogger<GenreController> logger) : base(service, logger) { }
        
        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> Post([FromBody] GenreUpsertDTO upsertDTO)
        {
            return await base.Post(upsertDTO);
        }

        [Authorize(Roles = "Administrator")]
        public override async Task<IActionResult> Put([FromBody] GenreUpsertDTO upsertDTO)
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
