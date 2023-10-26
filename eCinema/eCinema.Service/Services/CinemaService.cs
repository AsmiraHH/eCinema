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
    public class CinemaService : BaseService<Cinema, CinemaDTO, CinemaUpsertDTO, ICinemaRepository>, ICinemaService
    {
        public CinemaService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<CinemaUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
