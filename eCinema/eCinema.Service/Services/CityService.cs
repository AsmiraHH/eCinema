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
    public class CityService : BaseService<City, CityDTO, CityUpsertDTO, CitySearchObject, ICityRepository>, ICityService
    {
        public CityService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<CityUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
