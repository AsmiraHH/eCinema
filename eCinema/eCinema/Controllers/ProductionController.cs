using eCinema.Core.DTOs;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class ProductionController : BaseController<ProductionDTO, ProductionUpsertDTO, IProductionService>
    {
        public ProductionController(IProductionService service) : base(service) { }
    }
}
