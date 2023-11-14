using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;

namespace eCinema.Core
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<ActorDTO, Actor>().ReverseMap();
            CreateMap<ActorUpsertDTO, Actor>();

            CreateMap<CinemaDTO, Cinema>().ReverseMap();
            CreateMap<CinemaUpsertDTO, Cinema>();

            CreateMap<CityDTO, City>().ReverseMap();
            CreateMap<CityUpsertDTO, City>();

            CreateMap<CountryDTO, Country>().ReverseMap();
            CreateMap<CountryUpsertDTO, Country>();

            CreateMap<EmployeeDTO, Employee>().ReverseMap();
            CreateMap<EmployeeUpsertDTO, Employee>();

            CreateMap<GenreDTO, Genre>().ReverseMap();
            CreateMap<GenreUpsertDTO, Genre>();

            CreateMap<HallDTO, Hall>().ReverseMap();
            CreateMap<HallUpsertDTO, Hall>();

            CreateMap<LanguageDTO, Language>().ReverseMap();
            CreateMap<LanguageUpsertDTO, Language>();

            CreateMap<MovieDTO, Movie>().ReverseMap();
            CreateMap<MovieUpsertDTO, Movie>();

            CreateMap<MovieActorDTO, MovieActor>().ReverseMap();
            CreateMap<MovieActorUpsertDTO, MovieActor>();

            CreateMap<MovieGenreDTO, MovieGenre>().ReverseMap();
            CreateMap<MovieGenreUpsertDTO, MovieGenre>();

            CreateMap<ProductionDTO, Production>().ReverseMap();
            CreateMap<ProductionUpsertDTO, Production>();

            CreateMap<ReservationDTO, Reservation>().ReverseMap();
            CreateMap<ReservationUpsertDTO, Reservation>();

            CreateMap<SeatDTO, Seat>().ReverseMap();
            CreateMap<SeatUpsertDTO, Seat>();

            CreateMap<ShowDTO, Show>().ReverseMap();
            CreateMap<ShowUpsertDTO, Show>();

            CreateMap<UserDTO, User>().ReverseMap();
            CreateMap<UserUpsertDTO, User>();
        }
    }
}
