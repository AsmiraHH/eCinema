using eCinema.Core.Exceptions;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    [ApiController]
    [Route("[controller]/[action]")]
    [Authorize(Roles = "Administrator,User")]
    public abstract class BaseController<TDTO, TUpsertDTO, TSearchObject, TService> : Controller
        where TDTO : class
        where TUpsertDTO : class
        where TSearchObject : BaseSearchObject
        where TService : IBaseService<int, TDTO, TUpsertDTO, TSearchObject>
    {
        protected readonly TService service;
        protected readonly ILogger<BaseController<TDTO, TUpsertDTO, TSearchObject, TService>> logger;
        public BaseController(TService service, ILogger<BaseController<TDTO, TUpsertDTO, TSearchObject, TService>> logger)
        {
            this.service = service;
            this.logger = logger;
        }

        [HttpGet("{id}")]
        public virtual async Task<IActionResult> Get(int id)
        {
            try
            {
                var dto = await service.GetByIdAsync(id);
                return Ok(dto);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while getting object with ID {id}", id);
                return BadRequest();
            }
        }

        [HttpGet]
        public virtual async Task<IActionResult> GetPaged([FromQuery] TSearchObject searchObject)
        {
            try
            {
                var dto = await service.GetPagedAsync(searchObject);
                return Ok(dto);
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Error while getting paged object with page number {searchObject.PageNumber} and page size {searchObject.PageSize}", searchObject.PageNumber, searchObject.PageSize);
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
                logger.LogError(e, $"Error while posting an object");
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
                logger.LogError(e, $"Error while updating an object");
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
                logger.LogError(e, $"Error while deleting an object with ID {id}", id);
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
