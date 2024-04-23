using eCinema.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Core.SearchObjects
{
    public class ReservationSearchObject : BaseSearchObject
    {
        public string? Movie{ get; set; }
        public int? Cinema { get; set; }
        public int? User { get; set; }
    }
}
