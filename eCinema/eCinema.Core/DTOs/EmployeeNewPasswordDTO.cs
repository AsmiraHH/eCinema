using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Core.DTOs
{
    public class EmployeeNewPasswordDTO
    {
        public int ID { get; set; }
        public string Password { get; set; } = null!;
        public string NewPassword { get; set; } = null!;
    }
}
