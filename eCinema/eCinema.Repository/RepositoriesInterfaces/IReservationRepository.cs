using eCinema.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Repository.RepositoriesInterfaces
{
    public interface IReservationRepository : IBaseRepository<Reservation, int>
    {
    }
}
