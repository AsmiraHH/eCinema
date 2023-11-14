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
    public class MovieActorService : BaseService<MovieActor,MovieActorDTO, MovieActorUpsertDTO, BaseSearchObject, IMovieActorRepository>, IMovieActorService
    {
        public MovieActorService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<MovieActorUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
