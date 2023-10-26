using AutoMapper;
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
    public abstract class BaseService<TEntity, TDTO, TUpsertDTO, TRepository> : IBaseService<int, TDTO, TUpsertDTO>
        where TEntity : class
        where TDTO : class
        where TUpsertDTO : class
        where TRepository : class, IBaseRepository<TEntity, int>
    {
        protected readonly IMapper Mapper;
        protected readonly UnitOfWork UnitOfWork;
        protected readonly TRepository CurrentRepository;
        protected readonly IValidator<TUpsertDTO> Validator;

        protected BaseService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<TUpsertDTO> validator)
        {
            Mapper = mapper;
            UnitOfWork = (UnitOfWork)unitOfWork;
            Validator = validator;
            CurrentRepository = (TRepository)unitOfWork.GetType()
                                                       .GetFields()
                                                       .First(f => f.FieldType == typeof(TRepository))
                                                       .GetValue(unitOfWork)!;
        }
        public virtual async Task<TDTO?> GetByIdAsync(int id)
        {
            var entity = await CurrentRepository.GetByIdAsync(id);
            return Mapper.Map<TDTO>(entity);
        }
        public virtual async Task<TDTO> AddAsync(TUpsertDTO dto)
        {
            var entity = Mapper.Map<TEntity>(dto);
            await CurrentRepository.AddAsync(entity);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<TDTO>(entity);
        }

        public virtual async Task<TDTO> UpdateAsync(TUpsertDTO dto)
        {
            var entity = Mapper.Map<TEntity>(dto);
            CurrentRepository.Update(entity);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<TDTO>(entity);
        }

        public virtual async Task DeleteAsync(TDTO dto)
        {
            var entity = Mapper.Map<TEntity>(dto);
            CurrentRepository.Delete(entity);
            await UnitOfWork.SaveChangesAsync();
        }

        public virtual async Task DeleteByIdAsync(int id)
        {
            await CurrentRepository.DeleteByIdAsync(id);
            await UnitOfWork.SaveChangesAsync();
        }
    }
}
