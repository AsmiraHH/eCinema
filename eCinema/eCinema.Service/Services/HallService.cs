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
    public class HallService : BaseService<Hall, HallDTO, HallUpsertDTO, HallSearchObject, IHallRepository>, IHallService
    {

        public HallService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<HallUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
