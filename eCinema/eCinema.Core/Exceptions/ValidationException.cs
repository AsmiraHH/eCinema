using eCinema.Core.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Core.Exceptions
{
    public class ValidationException : Exception
    {
        public List<ValidationError> Errors { get; set; }

        public ValidationException(List<ValidationError> errors) 
        {
            this.Errors = errors;
        }
    }
}
