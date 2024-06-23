using eCinema.Core.DTOs;
using FluentValidation;

namespace eCinema.Service.Validators
{
    public class ReservationValidator : AbstractValidator<ReservationUpsertDTO>
    {
        public ReservationValidator()
        {
            RuleFor(a => a.isActive).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.TransactionNumber).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.SeatIDs).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.ShowId).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.UserId).NotNull().WithErrorCode("NotNull");
        }
    }
}
