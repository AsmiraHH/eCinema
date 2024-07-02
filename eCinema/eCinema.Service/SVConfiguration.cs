using eCinema.Core.DTOs;
using eCinema.Service.CryptoService;
using eCinema.Service.MailService;
using eCinema.Service.ServiceInterfaces;
using eCinema.Service.Services;
using eCinema.Service.Validators;
using FluentValidation;
using Microsoft.Extensions.DependencyInjection;

namespace eCinema.Service
{
    public static class SVConfiguration
    {
        public static void ConfigureServices(this IServiceCollection services)
        {
            services.AddScoped<IActorService, ActorService>();
            services.AddScoped<ICinemaService, CinemaService>();
            services.AddScoped<ICityService, CityService>();
            services.AddScoped<ICountryService, CountryService>();
            services.AddScoped<IEmployeeService, EmployeeService>();
            services.AddScoped<IGenreService, GenreService>();
            services.AddScoped<ILanguageService, LanguageService>();
            services.AddScoped<IMovieActorService, MovieActorService>();
            services.AddScoped<IMovieGenreService, MovieGenreService>();
            services.AddScoped<IMovieService, MovieService>();
            services.AddScoped<IProductionService, ProductionService>();
            services.AddScoped<IReservationService, ReservationService>();
            services.AddScoped<IReservationSeatService, ReservationSeatService>();
            services.AddScoped<ISeatService, SeatService>();
            services.AddScoped<IHallService, HallService>();
            services.AddScoped<IShowService, ShowService>();
            services.AddScoped<IUserService, UserService>();
            services.AddScoped<ICryptoService, CryptoService.CryptoService>();
            services.AddScoped<IMailService, MailService.MailService>();
        }

        public static void ConfigureValidators(this IServiceCollection services)
        {
            services.AddScoped<IValidator<ActorUpsertDTO>, ActorValidator>();
            services.AddScoped<IValidator<CinemaUpsertDTO>, CinemaValidator>();
            services.AddScoped<IValidator<CityUpsertDTO>, CityValidator>();
            services.AddScoped<IValidator<CountryUpsertDTO>, CountryValidator>();
            services.AddScoped<IValidator<EmployeeUpsertDTO>, EmployeeValidator>();
            services.AddScoped<IValidator<GenreUpsertDTO>, GenreValidator>();
            services.AddScoped<IValidator<LanguageUpsertDTO>, LanguageValidator>();
            services.AddScoped<IValidator<MovieActorUpsertDTO>, MovieActorValidator>();
            services.AddScoped<IValidator<MovieGenreUpsertDTO>, MovieGenreValidator>();
            services.AddScoped<IValidator<MovieUpsertDTO>, MovieValidator>();
            services.AddScoped<IValidator<ProductionUpsertDTO>, ProductionValidator>();
            services.AddScoped<IValidator<ReservationUpsertDTO>, ReservationValidator>();
            services.AddScoped<IValidator<ReservationSeatUpsertDTO>, ReservationSeatValidator>();
            services.AddScoped<IValidator<SeatUpsertDTO>, SeatValidator>();
            services.AddScoped<IValidator<HallUpsertDTO>, HallValidator>();
            services.AddScoped<IValidator<ShowUpsertDTO>, ShowValidator>();
            services.AddScoped<IValidator<UserUpsertDTO>, UserValidator>();
        }
    }
}
