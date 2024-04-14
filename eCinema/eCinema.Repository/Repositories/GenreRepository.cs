using eCinema.Core.Entities;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Repository.Repositories
{
    public class GenreRepository : BaseRepository<Genre, int, GenreSearchObject>, IGenreRepository
    {
        public GenreRepository(DatabaseContext db) : base(db) { }
        public override async Task<PagedList<Genre>> GetPagedAsync(GenreSearchObject searchObject)
        {
            var items = dbSet.OrderBy(x => x.Name).AsQueryable();

            if (!string.IsNullOrEmpty(searchObject.Name))
                items = items.Where(x => x.Name.ToLower().Contains(searchObject.Name.ToLower()));

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
    }
}
