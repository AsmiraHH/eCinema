using eCinema.Core.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
        Task<List<TEntity>> GetPagedAsync(TSearchObject searchObject);
        Task DeleteByIdAsync(TPrimaryKey id);
    }
}
