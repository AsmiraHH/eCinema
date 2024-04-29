using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class ReservationRepository : BaseRepository<Reservation, int, ReservationSearchObject>, IReservationRepository
    {
        public ReservationRepository(DatabaseContext db) : base(db) { }
        public override async Task<PagedList<Reservation>> GetPagedAsync(ReservationSearchObject searchObject)
        {
            var items = dbSet.Include(x => x.User).Include(x => x.Seat).Include(x => x.Show).ThenInclude(x => x.Movie)
                             .Include(x => x.Show).ThenInclude(x => x.Hall).ThenInclude(x => x.Cinema).OrderByDescending(x => x.ID).AsQueryable();

            if (searchObject.Cinema != null)
                items = items.Where(x => x.Show.Hall.Cinema.ID == searchObject.Cinema);
            if (searchObject.User != null)
                items = items.Where(x => x.UserId == searchObject.User);
            if (searchObject.Movie != null)
                items = items.Where(x => x.Show.Movie.Title.ToLower().Contains(searchObject.Movie.ToLower()));

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
        public virtual async Task<List<Reservation>> GetForReportAsync(ReportDTO dto)
        {
            var items = dbSet.Include(x => x.User).Include(x => x.Seat).Include(x => x.Show).ThenInclude(x => x.Movie)
                             .Include(x => x.Show).ThenInclude(x => x.Hall).ThenInclude(x => x.Cinema).OrderByDescending(x => x.ID).AsQueryable();

            if (dto.Cinema != null)
                items = items.Where(x => x.Show.Hall.Cinema.ID == dto.Cinema);
            if (dto.Month != null && dto.Month != 0)
                items = items.Where(x => x.Show.DateTime.Month == dto.Month);
            if (dto.Genre != null)
                items = items.Where(x => x.Show.Movie.Genres.Any(y => y.GenreId == dto.Genre));
            if (dto.User != null)
                items = items.Where(x => x.User.ID == dto.User);

            return await items.ToListAsync();
        }
        public virtual async Task<IEnumerable<Reservation>> GetByUserID(int userID)
        {
            return await dbSet.Include(x => x.Show).Where(x => x.UserId == userID).ToListAsync();
        }
        public virtual async Task DeleteByShowIdsAsync(List<int> ids)
        {
            foreach (var id in ids)
            {
                var resEntities = await dbSet.Where(x => x.ShowId == id).ToListAsync();
                if (resEntities != null)
                    dbSet.RemoveRange(resEntities);
            }
        }
    }
}
