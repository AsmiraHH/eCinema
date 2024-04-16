using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Repository.UnitOfWork;
using eCinema.Service.ServiceInterfaces;
using FluentValidation;

namespace eCinema.Service.Services
{
    public class CountryService : BaseService<Country, CountryDTO, CountryUpsertDTO, CountrySearchObject, ICountryRepository>, ICountryService
    {
        public CountryService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<CountryUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
