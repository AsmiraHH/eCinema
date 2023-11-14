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
    public class CinemaService : BaseService<Cinema, CinemaDTO, CinemaUpsertDTO, BaseSearchObject, ICinemaRepository>, ICinemaService
    {
        public CinemaService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<CinemaUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
