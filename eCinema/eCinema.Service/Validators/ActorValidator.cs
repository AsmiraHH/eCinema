using eCinema.Core.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Validators
{
    public class ActorValidator : AbstractValidator<ActorUpsertDTO>
    {
        public ActorValidator()
        {
            RuleFor(a => a.FirstName).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.LastName).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.Email).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.BirthDate).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.Gender).NotNull().WithErrorCode("NotNull");
        }
    }
}
