using eCinema.Core.Entities;
using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.Repository.RepositoriesInterfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Repository.Repositories
{
    public class ActorRepository : BaseRepository<Actor, int, ActorSearchObject>, IActorRepository
    {
        public ActorRepository(DatabaseContext db) : base(db) { }
        public override async Task<PagedList<Actor>> GetPagedAsync(ActorSearchObject searchObject)
        {
            var items = dbSet.AsQueryable();

            if (searchObject.Name != null)
                items = items.Where(x => (x.FirstName + " " + x.LastName).ToLower().Contains(searchObject.Name.ToLower()));
            if (searchObject.Gender != null)
                items = items.Where(x => x.Gender == searchObject.Gender);

            var result = await items.ToPagedListAsync(searchObject);

            return result;
        }
    }
}
