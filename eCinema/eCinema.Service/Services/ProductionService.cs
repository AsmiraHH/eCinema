using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Repository.UnitOfWork;
using eCinema.Service.ServiceInterfaces;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Services
{
    public class ProductionService : BaseService<Production, ProductionDTO, ProductionUpsertDTO, BaseSearchObject, IProductionRepository>, IProductionService
    {
        public ProductionService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ProductionUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
