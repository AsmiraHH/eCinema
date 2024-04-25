using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class SeatRepository : BaseRepository<Seat, int, BaseSearchObject>, ISeatRepository
    {
        public SeatRepository(DatabaseContext db) : base(db) { }
        public virtual async Task AddRangeAsync(List<Seat> entities)
        {
            await dbSet.AddRangeAsync(entities);
        }
        public async Task<List<Seat>?> GetByHallIdAsync(int hallId)
        {
            return await dbSet.Where(x => x.HallId == hallId).ToListAsync();
        }
    }
}
