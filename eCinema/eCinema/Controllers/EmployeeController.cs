using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;

namespace eCinema.Controllers
{

    [Authorize(Roles = "Administrator")]
    public class EmployeeController : BaseController<EmployeeDTO, EmployeeUpsertDTO, EmployeeSearchObject, IEmployeeService>
    {
        public EmployeeController(IEmployeeService service, ILogger<EmployeeController> logger) : base(service, logger) { }
    }
}
