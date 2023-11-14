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
    public class MovieGenreService : BaseService<MovieGenre, MovieGenreDTO, MovieGenreUpsertDTO, BaseSearchObject, IMovieGenreRepository>, IMovieGenreService
    {
        public MovieGenreService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<MovieGenreUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
