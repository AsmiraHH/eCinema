using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Core.Helpers
{
    public class ValidationError
    {
        public string ErrorCode { get; set; } = null!;
        public string ErrorMessage { get; set; } = null!;
        public string PropertyName { get; set; } = null!;
    }
}
