using eCinema.Core.Exceptions;
using eCinema.Core.Helpers;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    [ApiController]
    [Route("[controller]/[action]")]
    public abstract class BaseController<TDTO, TUpsertDTO, TService> : Controller
        where TDTO : class
        where TUpsertDTO : class
        where TService : IBaseService<int, TDTO, TUpsertDTO>
    {
        protected readonly TService service;

        public BaseController(TService service)
        {
            this.service = service;
        }

        [HttpGet("{id}")]
        public virtual async Task<IActionResult> Get(int id)
        {
            try
            {
                var dto = await service.GetByIdAsync(id);
                return Ok(dto);
            }
            catch (Exception)
            {
                return BadRequest();
            }
        }

        [HttpPost]
        public virtual async Task<IActionResult> Post([FromBody] TUpsertDTO upsertDTO)
        {
            try
            {
                var dto = await service.AddAsync(upsertDTO);
                return Ok(dto);
            }
            catch (ValidationException e)
            {
                return ValidationResult(e.Errors);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPut]
        public virtual async Task<IActionResult> Put([FromBody] TUpsertDTO upsertDTO)
        {
            try
            {
                var dto = await service.UpdateAsync(upsertDTO);
                return Ok(dto);
            }
            catch (ValidationException e)
            {
                return ValidationResult(e.Errors);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpDelete("{id}")]
        public virtual async Task<IActionResult> Delete(int id)
        {
            try
            {
                await service.DeleteByIdAsync(id);
                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        private IActionResult ValidationResult(List<ValidationError> Errors) //provjeriti
        {
            return BadRequest(Errors
                  .GroupBy(x => x.PropertyName)
                  .ToDictionary(
                    g => g.Key,
                    g => g.Select(x => x.ErrorMessage).ToArray()));
        }
    }
}
