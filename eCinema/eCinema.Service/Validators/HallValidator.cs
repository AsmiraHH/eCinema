using eCinema.Core.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Validators
{
    public class HallValidator : AbstractValidator<HallUpsertDTO>
    {
        public HallValidator()
        {
            RuleFor(a => a.Name).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.NumberOfSeats).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.NumberOfRows).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.MaxNumberOfSeatsPerRow).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.CinemaId).NotNull().WithErrorCode("NotNull");
        }
    }
}
