using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;

namespace eCinema.Repository.RepositoriesInterfaces
{
    public interface IBaseRepository<TEntity, in TPrimaryKey, TSearchObject>
        where TEntity : class
        where TSearchObject : BaseSearchObject
    {
        Task AddAsync(TEntity entity);
        void Update(TEntity entity);
        void Delete(TEntity entity);
        Task<TEntity?> GetByIdAsync(TPrimaryKey id);
        Task<PagedList<TEntity>> GetPagedAsync(TSearchObject searchObject);
        Task DeleteByIdAsync(TPrimaryKey id);
    }
}
