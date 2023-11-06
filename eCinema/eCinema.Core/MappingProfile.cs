using AutoMapper;
using eCinema.Core.DTOs;
using eCinema.Core.Entities;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Core
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<ActorDTO, Actor>();
            CreateMap<ActorUpsertDTO, Actor>();

            CreateMap<CinemaDTO, Cinema>();
            CreateMap<CinemaUpsertDTO, Cinema>();

            CreateMap<CityDTO, City>();
            CreateMap<CityUpsertDTO, City>();

            CreateMap<CountryDTO, Country>();
            CreateMap<CountryUpsertDTO, Country>();

            CreateMap<EmployeeDTO, Employee>();
            CreateMap<EmployeeDTO, Employee>();

            CreateMap<GenreDTO, Genre>();
            CreateMap<GenreUpsertDTO, Genre>();

            CreateMap<HallDTO, Hall>();
            CreateMap<HallDTO, Hall>();

            CreateMap<LanguageDTO, Language>();
            CreateMap<LanguageUpsertDTO, Language>();

            CreateMap<MovieDTO, Movie>();
            CreateMap<MovieUpsertDTO, Movie>();

            CreateMap<MovieActorDTO, MovieActor>();
            CreateMap<MovieActorUpsertDTO, MovieActorDTO>();

            CreateMap<MovieGenreDTO, MovieGenre>();
            CreateMap<MovieGenreUpsertDTO, MovieGenre>();

            CreateMap<ProductionDTO, Production>();
            CreateMap<ProductionUpsertDTO, Production>();

            CreateMap<ReservationDTO, Reservation>();
            CreateMap<ReservationUpsertDTO, Reservation>();

            CreateMap<SeatDTO, Seat>();
            CreateMap<SeatDTO, Seat>();

            CreateMap<ShowDTO, Show>();
            CreateMap<ShowUpsertDTO, Show>();

            CreateMap<UserDTO, User>();
            CreateMap<UserUpsertDTO, User>();
        }
    }
}
