using eCinema.Core.Helpers;

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
