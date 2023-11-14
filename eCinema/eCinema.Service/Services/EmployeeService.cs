using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Core.Exceptions;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Repository.UnitOfWork;
using eCinema.Service.CryptoService;
using eCinema.Service.ServiceInterfaces;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Services
{
    public class EmployeeService : BaseService<Employee, EmployeeDTO, EmployeeUpsertDTO, BaseSearchObject, IEmployeeRepository>, IEmployeeService
    {
        private readonly ICryptoService cryptoService;

        public EmployeeService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<EmployeeUpsertDTO> validator, ICryptoService _cryptoService) : base(mapper, unitOfWork, validator)
        {
            cryptoService = _cryptoService;
        }
        public override async Task<EmployeeDTO> AddAsync(EmployeeUpsertDTO upsertDTO)
        {
            await ValidateAsync(upsertDTO);

            var entity = Mapper.Map<Employee>(upsertDTO);

            entity.PasswordSalt = cryptoService.GenerateSalt();
            entity.PasswordHash = cryptoService.GenerateHash(upsertDTO.Password!, entity.PasswordSalt);

            await CurrentRepository.AddAsync(entity);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<EmployeeDTO>(entity);
        }

        public override async Task<EmployeeDTO> UpdateAsync(EmployeeUpsertDTO upsertDTO)
        {
            var entity = await CurrentRepository.GetByIdAsync(upsertDTO.ID.Value);
            if (entity == null)
                throw new UserNotFoundException();

            Mapper.Map(upsertDTO, entity);

            if (!string.IsNullOrEmpty(upsertDTO.Password))
            {
                entity.PasswordSalt = cryptoService.GenerateSalt();
                entity.PasswordHash = cryptoService.GenerateHash(upsertDTO.Password, entity.PasswordSalt);
            }

            CurrentRepository.Update(entity);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<EmployeeDTO>(entity);
        }

        public async Task ChangePassword(EmployeeNewPasswordDTO dto)
        {
            var employee = await CurrentRepository.GetByIdAsync(dto.ID);

            if (employee == null)
                throw new UserNotFoundException();

            if (!cryptoService.VerifyPassword(employee.PasswordHash, dto.Password, employee.PasswordSalt))
                throw new UserWrongCredentialsException();

            employee.PasswordSalt = cryptoService.GenerateSalt();
            employee.PasswordHash = cryptoService.GenerateHash(dto.NewPassword, employee.PasswordSalt);

            CurrentRepository.Update(employee);
            await UnitOfWork.SaveChangesAsync();
        }
    }
}
