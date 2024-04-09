using AutoMapper;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Repository.UnitOfWork;
using eCinema.Core.Helpers;
using eCinema.Service.ServiceInterfaces;
using FluentValidation;
using eCinema.Core.SearchObjects;
using System.Threading;

namespace eCinema.Service.Services
{
    public abstract class BaseService<TEntity, TDTO, TUpsertDTO, TSearchObject, TRepository> : IBaseService<int, TDTO, TUpsertDTO, TSearchObject>
        where TEntity : class
        where TDTO : class
        where TUpsertDTO : class
        where TSearchObject : BaseSearchObject
        where TRepository : class, IBaseRepository<TEntity, int, TSearchObject>
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
        public virtual async Task<List<TDTO>?> GetAllAsync()
        {
            var entities = await CurrentRepository.GetAllAsync();
            return Mapper.Map<List<TDTO>>(entities);
        }
        public virtual async Task<PagedList<TDTO>> GetPagedAsync(TSearchObject searchObject)
        {
            var list = await CurrentRepository.GetPagedAsync(searchObject);
            return Mapper.Map<PagedList<TDTO>>(list);
        }
        public virtual async Task<TDTO> AddAsync(TUpsertDTO dto)
        {
            await ValidateAsync(dto);

            var entity = Mapper.Map<TEntity>(dto);
            await CurrentRepository.AddAsync(entity);
            await UnitOfWork.SaveChangesAsync();
            return Mapper.Map<TDTO>(entity);
        }

        public virtual async Task<TDTO> UpdateAsync(TUpsertDTO dto)
        {
            await ValidateAsync(dto);

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
        protected async Task ValidateAsync(TUpsertDTO dto)
        {
            var validationResult = await Validator.ValidateAsync(dto);
            if (validationResult.IsValid == false)
            {
                throw new Core.Exceptions.ValidationException(Mapper.Map<List<ValidationError>>(validationResult.Errors));
            }
        }

    }
}
