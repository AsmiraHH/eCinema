using eCinema.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Core.SearchObjects
{
    public class MovieSearchObject : BaseSearchObject
    {
        public string? Title{ get; set; }
        public int? Genre { get; set; }
        public int? Language { get; set; }
        public int? Production { get; set; }
        public int? Cinema { get; set; }
    }
}
