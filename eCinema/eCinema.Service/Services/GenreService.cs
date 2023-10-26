using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;
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
    public class GenreService : BaseService<Genre, GenreDTO, GenreUpsertDTO, IGenreRepository>, IGenreService
    {
        public GenreService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<GenreUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
