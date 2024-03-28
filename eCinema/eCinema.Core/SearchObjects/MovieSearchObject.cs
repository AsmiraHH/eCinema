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
        public int? Genre { get; set; }
        public string? Title{ get; set; }
    }
}
