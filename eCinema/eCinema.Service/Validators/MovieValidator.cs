using eCinema.Core.DTOs;
using FluentValidation;

namespace eCinema.Service.Validators
{
    public class MovieValidator : AbstractValidator<MovieUpsertDTO>
    {
        public MovieValidator()
        {
            RuleFor(a => a.Title).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.Description).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.Author).NotEmpty().WithErrorCode("NotEmpty");
            RuleFor(a => a.ReleaseYear).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.Duration).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.PhotoBase64).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.LanguageId).NotNull().WithErrorCode("NotNull");
            RuleFor(a => a.ProductionId).NotNull().WithErrorCode("NotNull");
        }
    }
}
