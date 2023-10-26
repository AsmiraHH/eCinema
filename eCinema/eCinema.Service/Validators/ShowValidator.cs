using eCinema.Core.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Validators
{
    public class ShowValidator : AbstractValidator<ShowUpsertDTO>
    {
        public ShowValidator()
        {
            RuleFor(a => a.Date).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.StartTime).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.Format).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.Price).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.HallId).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.MovieId).NotNull().WithErrorCode("NotNull");
        }
    }
}
