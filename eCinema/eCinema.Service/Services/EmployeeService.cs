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
    public class EmployeeService : BaseService<Employee, EmployeeDTO, EmployeeUpsertDTO, IEmployeeRepository>, IEmployeeService
    {
        public EmployeeService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<EmployeeUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
