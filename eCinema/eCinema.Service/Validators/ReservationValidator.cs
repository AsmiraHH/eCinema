using eCinema.Core.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Validators
{
    public class ReservationValidator : AbstractValidator<ReservationUpsertDTO>
    {
        public ReservationValidator()
        {
            RuleFor(a => a.isActive).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.SeatId).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.ShowId).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.UserId).NotNull().WithErrorCode("NotNull");
        }
    }
}
