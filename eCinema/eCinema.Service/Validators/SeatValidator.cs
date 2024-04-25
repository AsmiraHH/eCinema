using eCinema.Core.DTOs;
using FluentValidation;

namespace eCinema.Service.Validators
{
    public class SeatValidator : AbstractValidator<SeatUpsertDTO>
    {
        public SeatValidator()
        {
            RuleFor(a => a.numRows).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.numColumns).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.HallId).NotNull().WithErrorCode("NotNull");
        }
    }
}
