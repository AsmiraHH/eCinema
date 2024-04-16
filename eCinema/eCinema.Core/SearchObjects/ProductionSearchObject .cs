using eCinema.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Core.SearchObjects
{
    public class ProductionSearchObject : BaseSearchObject
    {
        public string? Name{ get; set; }
        public int? Country{ get; set; }
    }
}
