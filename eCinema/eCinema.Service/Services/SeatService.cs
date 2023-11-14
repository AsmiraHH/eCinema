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
    public class SeatService : BaseService<Seat, SeatDTO, SeatUpsertDTO, BaseSearchObject, ISeatRepository>, ISeatService
    {
        public SeatService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<SeatUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
