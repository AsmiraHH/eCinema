using eCinema.Repository.Repositories;
using eCinema.Repository.RepositoriesInterfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Repository.UnitOfWork
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly DatabaseContext _db;

        public readonly IActorRepository ActorRepository;
        public readonly ICinemaRepository CinemaRepository;
        public readonly ICityRepository CityRepository;
        public readonly ICountryRepository CountryRepository;
        public readonly IEmployeeRepository EmployeeRepository;
        public readonly IGenreRepository GenreRepository;
        public readonly ILanguageRepository LanguageRepository;
        public readonly IMovieActorRepository MovieActorRepository;
        public readonly IMovieGenreRepository MovieGenreRepository;
        public readonly IMovieRepository MovieRepository;
        public readonly IProductionRepository ProductionRepository;
        public readonly IReservationRepository ReservationRepository;
        public readonly ISeatRepository SeatRepository;
        public readonly IShowRepository ShowRepository;
        public readonly IUserRepository UserRepository;

        public UnitOfWork(
        DatabaseContext db,
            IActorRepository actorRepository,
            ICinemaRepository cinemaRepository,
            ICityRepository cityRepository,
            ICountryRepository countryRepository,
            IEmployeeRepository employeeRepository,
            IGenreRepository genreRepository,
            ILanguageRepository languageRepository,
            IMovieActorRepository movieActorRepository,
            IMovieGenreRepository movieGenreRepository,
            IMovieRepository movieRepository,
            IProductionRepository productionRepository,
            IReservationRepository reservationRepository,
            ISeatRepository seatRepository,
            IShowRepository showRepository,
            IUserRepository userRepository)
        {
            _db = db;
            ActorRepository = actorRepository;
            CinemaRepository = cinemaRepository;
            CityRepository = cityRepository;
            CountryRepository = countryRepository;
            EmployeeRepository = employeeRepository;
            GenreRepository = genreRepository;
            LanguageRepository = languageRepository;
            MovieActorRepository = movieActorRepository;
            MovieGenreRepository = movieGenreRepository;
            MovieRepository = movieRepository;
            ProductionRepository = productionRepository;
            ReservationRepository = reservationRepository;
            SeatRepository = seatRepository;
            ShowRepository = showRepository;
            UserRepository = userRepository;
        }
        public async Task<int> SaveChangesAsync()
        {
            return await _db.SaveChangesAsync();
        }

    }
}
