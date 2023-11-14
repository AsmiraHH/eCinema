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
    public class MovieService : BaseService<Movie, MovieDTO, MovieUpsertDTO, MovieSearchObject, IMovieRepository>, IMovieService
    {
        public MovieService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<MovieUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
