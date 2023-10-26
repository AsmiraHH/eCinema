using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Repository.Repositories
{
    public abstract class BaseRepository<TEntity, TPrimaryKey> : IBaseRepository<TEntity, TPrimaryKey> where TEntity : class
    {
        protected readonly DatabaseContext db;
        protected readonly DbSet<TEntity> dbSet;
        public BaseRepository(DatabaseContext _db)
        {
            db = _db;
            dbSet = _db.Set<TEntity>();
        }
        public virtual async Task AddAsync(TEntity entity)
        {
            await dbSet.AddAsync(entity);
        }
        public void Update(TEntity entity)
        {
            dbSet.Update(entity);
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
    }
}
