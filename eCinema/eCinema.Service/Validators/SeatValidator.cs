using eCinema.Core.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Validators
{
    public class SeatValidator : AbstractValidator<SeatUpsertDTO>
    {
        public SeatValidator()
        {
            RuleFor(a => a.Row).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.Column).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.HallId).NotNull().WithErrorCode("NotNull");
        }
    }
}
