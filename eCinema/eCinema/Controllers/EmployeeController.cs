using eCinema.Core.DTOs;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class EmployeeController : BaseController<EmployeeDTO, EmployeeUpsertDTO, IEmployeeService>
    {
        public EmployeeController(IEmployeeService service) : base(service) { }
    }
}
