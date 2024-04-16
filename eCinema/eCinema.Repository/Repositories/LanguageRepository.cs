using eCinema.Core.Entities;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;

namespace eCinema.Repository.Repositories
{
    public class LanguageRepository : BaseRepository<Language, int, LanguageSearchObject>, ILanguageRepository
    {
        public LanguageRepository(DatabaseContext db) : base(db) { }
        public override async Task<PagedList<Language>> GetPagedAsync(LanguageSearchObject searchObject)
        {
            var items = dbSet.OrderBy(x => x.Name).AsQueryable();

            if (!string.IsNullOrEmpty(searchObject.Name))
                items = items.Where(x => x.Name.ToLower().Contains(searchObject.Name.ToLower()));

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
    }
}
