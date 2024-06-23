using eCinema.Repository.Repositories;
using eCinema.Repository.RepositoriesInterfaces;
using eCinema.Repository.UnitOfWork;
using Microsoft.Extensions.DependencyInjection;

namespace eCinema.Repository
{
    public static class RepositoriesConfiguration
    {
        public static void ConfigureRepositories(this IServiceCollection services)
        {
            services.AddScoped<IActorRepository, ActorRepository>();
            services.AddScoped<ICinemaRepository, CinemaRepository>();
            services.AddScoped<ICityRepository, CityRepository>();
            services.AddScoped<ICountryRepository, CountryRepository>();
            services.AddScoped<IEmployeeRepository, EmployeeRepository>();
            services.AddScoped<IGenreRepository, GenreRepository>();
            services.AddScoped<IHallRepository, HallRepository>();
            services.AddScoped<ILanguageRepository, LanguageRepository>();
            services.AddScoped<IMovieActorRepository, MovieActorRepository>();
            services.AddScoped<IMovieGenreRepository, MovieGenreRepository>();
            services.AddScoped<IMovieRepository, MovieRepository>();
            services.AddScoped<IProductionRepository, ProductionRepository>();
            services.AddScoped<IReservationRepository, ReservationRepository>();
            services.AddScoped<IReservationSeatRepository, ReservationSeatRepository>();
            services.AddScoped<ISeatRepository, SeatRepository>();
            services.AddScoped<IHallRepository, HallRepository>();
            services.AddScoped<IShowRepository, ShowRepository>();
            services.AddScoped<IUserRepository, UserRepository>();

            services.AddScoped<IUnitOfWork, UnitOfWork.UnitOfWork>();
        }
    }
}
