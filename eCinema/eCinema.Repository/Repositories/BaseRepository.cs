using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public abstract class BaseRepository<TEntity, TPrimaryKey, TSearchObject> : IBaseRepository<TEntity, TPrimaryKey, TSearchObject>
        where TEntity : class
        where TSearchObject : BaseSearchObject
    {
        protected readonly DatabaseContext db;
        protected readonly DbSet<TEntity> dbSet;
        public BaseRepository(DatabaseContext _db)
        {
            db = _db;
            dbSet = _db.Set<TEntity>();
        }
        public virtual async Task<List<TEntity>?> GetAllAsync()
        {
            return await dbSet.ToListAsync();
        }
        public virtual async Task AddAsync(TEntity entity)
        {
            await dbSet.AddAsync(entity);
        }
        public void Update(TEntity entity)
        {
            dbSet.Update(entity);
        }
        public void UpdateRange(List<TEntity> entities)
        {
            dbSet.UpdateRange(entities);
        }

        public void Delete(TEntity entity)
        {
            dbSet.Remove(entity);
        }
        public virtual async Task DeleteByIdAsync(TPrimaryKey id)
        {
            var entity = await dbSet.FindAsync(id);
            if (entity != null)
                dbSet.Remove(entity);
        }
        public virtual async Task<TEntity?> GetByIdAsync(TPrimaryKey id)
        {
            return await dbSet.FindAsync(id);
        }
        public virtual async Task<PagedList<TEntity>> GetPagedAsync(TSearchObject searchObject)
        {
            return await dbSet.ToPagedListAsync(searchObject);
        }
    }
}
