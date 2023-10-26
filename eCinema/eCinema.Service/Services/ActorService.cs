using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Repository.Repositories;
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
    public class ActorService : BaseService<Actor, ActorDTO, ActorUpsertDTO, IActorRepository>, IActorService
    {
        public ActorService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ActorUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
