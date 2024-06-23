using eCinema.Core.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Validators
{
    public class ReservationSeatValidator : AbstractValidator<ReservationSeatUpsertDTO>
    {
        public ReservationSeatValidator()
        {
            RuleFor(a => a.ReservationId).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.SeatId).NotNull().WithErrorCode("NotNull");
        }
    }
}
