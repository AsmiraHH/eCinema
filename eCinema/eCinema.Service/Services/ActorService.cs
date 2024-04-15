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
    public class ActorService : BaseService<Actor, ActorDTO, ActorUpsertDTO, ActorSearchObject, IActorRepository>, IActorService
    {
        public ActorService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ActorUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
