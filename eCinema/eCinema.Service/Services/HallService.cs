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
    public class HallService : BaseService<Hall,HallDTO, HallUpsertDTO, IHallRepository>, IHallService
    {
        public HallService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<HallUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
