using eCinema.Core.DTOs;
using eCinema.Core.SearchObjects;
using eCinema.Service.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.Controllers
{
    public class ProductionController : BaseController<ProductionDTO, ProductionUpsertDTO, BaseSearchObject, IProductionService>
    {
        public ProductionController(IProductionService service) : base(service) { }
    }
}
