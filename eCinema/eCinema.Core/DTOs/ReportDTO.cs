using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Core.DTOs
{
    public  class ReportDTO
    {
        public int? Month { get; set; }         
        public int? Genre { get; set; }
        public int? Cinema { get; set; }         
        public int? User { get; set; }
    }
}
