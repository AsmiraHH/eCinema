using eCinema.Core.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.Validators
{
    public class MovieGenreValidator : AbstractValidator<MovieGenreUpsertDTO>
    {
        public MovieGenreValidator()
        {
            RuleFor(a => a.MovieId).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.GenreId).NotNull().WithErrorCode("NotNull");
        }
    }
}
