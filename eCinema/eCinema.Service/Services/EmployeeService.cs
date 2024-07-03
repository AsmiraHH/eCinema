using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Core.Exceptions;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Repository.UnitOfWork;
using eCinema.Service.ServiceInterfaces;
using FluentValidation;


namespace eCinema.Service.Services
{
    public class EmployeeService : BaseService<Employee, EmployeeDTO, EmployeeUpsertDTO, EmployeeSearchObject, IEmployeeRepository>, IEmployeeService
    {
        public EmployeeService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<EmployeeUpsertDTO> validator) : base(mapper, unitOfWork, validator)
        {
        }
        public override async Task<EmployeeDTO> AddAsync(EmployeeUpsertDTO upsertDTO)
        {
            await ValidateAsync(upsertDTO);

            var entity = Mapper.Map<Employee>(upsertDTO);

            if (!string.IsNullOrEmpty(upsertDTO?.PhotoBase64))
                entity.ProfilePhoto = Convert.FromBase64String(upsertDTO.PhotoBase64);

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

            if (!string.IsNullOrEmpty(upsertDTO?.PhotoBase64))
                entity.ProfilePhoto = Convert.FromBase64String(upsertDTO.PhotoBase64);

            CurrentRepository.Update(entity);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<EmployeeDTO>(entity);
        }
    }
}
