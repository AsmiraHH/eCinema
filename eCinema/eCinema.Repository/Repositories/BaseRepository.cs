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
        public void Add(TEntity entity)
        {
            dbSet.Add(entity);
            db.SaveChanges();
        }

        public void Delete(TEntity entity)
        {
            dbSet.Remove(entity);
            db.SaveChanges();
        }

        public void Update(TEntity entity)
        {
            dbSet.Update(entity);
            db.SaveChanges();
        }
        public virtual async Task<TEntity?> GetByIdAsync(TPrimaryKey id)
        {
            return await dbSet.FindAsync(id);
        }
    }
}
