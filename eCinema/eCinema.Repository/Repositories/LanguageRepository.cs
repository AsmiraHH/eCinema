using eCinema.Core.Entities;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Repository.Repositories
{
    public class LanguageRepository : BaseRepository<Language, int, BaseSearchObject>, ILanguageRepository
    {
        public LanguageRepository(DatabaseContext db) : base(db) { }

    }
}
