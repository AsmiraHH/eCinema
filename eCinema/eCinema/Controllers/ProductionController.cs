using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;

namespace eCinema.Controllers
{
    public class ProductionController : BaseController<ProductionDTO, ProductionUpsertDTO, BaseSearchObject, IProductionService>
    {
        public ProductionController(IProductionService service, ILogger<ProductionController> logger) : base(service, logger) { }
    }
}
