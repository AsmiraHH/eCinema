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
    public class CountryService : BaseService<Country, CountryDTO, CountryUpsertDTO, BaseSearchObject, ICountryRepository>, ICountryService
    {
        public CountryService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<CountryUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
