using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class ReservationSeatRepository : BaseRepository<ReservationSeat, int, BaseSearchObject>, IReservationSeatRepository
    {
        public ReservationSeatRepository(DatabaseContext db) : base(db) { }

        public async Task<List<Seat>?> GetByShowIdAsync(int showId)
        {
            return await dbSet.Where(x => x.Reservation.ShowId == showId).Select(x => x.Seat).ToListAsync();
        }
    }
}
