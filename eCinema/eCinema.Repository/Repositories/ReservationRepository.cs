using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class ReservationRepository : BaseRepository<Reservation, int, BaseSearchObject>, IReservationRepository
    {
        public ReservationRepository(DatabaseContext db) : base(db) { }

        public virtual async Task<IEnumerable<Reservation>> GetByUserID(int userID)
        {
            return await dbSet.Include(x => x.Show).Where(x => x.UserId == userID).ToListAsync();
        }
    }
}
