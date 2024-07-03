using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    [Authorize(Roles = "Administrator")]
    public class ProductionController : BaseController<ProductionDTO, ProductionUpsertDTO, ProductionSearchObject, IProductionService>
    {
        public ProductionController(IProductionService service, ILogger<ProductionController> logger) : base(service, logger) { }
    }
}
