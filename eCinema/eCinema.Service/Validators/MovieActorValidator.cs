using eCinema.Core.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Validators
{
    public class MovieActorValidator : AbstractValidator<MovieActorUpsertDTO>
    {
        public MovieActorValidator()
        {
            RuleFor(a => a.MovieId).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.ActorId).NotNull().WithErrorCode("NotNull");
        }
    }
}
