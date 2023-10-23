using eCinema.Core.Entities;
using eCinema.Core.Enums;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Repository
{
    public partial class DatabaseContext
    {
        private void SeedData(ModelBuilder modelBuilder)
        {
            SeedCountries(modelBuilder);
            SeedCities(modelBuilder);
            SeedLanguages(modelBuilder);
            SeedUsers(modelBuilder);
            SeedProduction(modelBuilder);
            SeedCinema(modelBuilder);
            SeedGenre(modelBuilder);
        }
        private void SeedCountries(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Country>().HasData(
              new()
              {
                  ID = 1,
                  Name = "Bosnia and Herzegovina",
              },
              new()
              {
                  ID = 2,
                  Name = "Croatia",
              },
              new()
              {
                  ID = 3,
                  Name = "Serbia",
              },
              new()
              {
                  ID = 4,
                  Name = "Australia",
              },
              new()
              {
                  ID = 5,
                  Name = "Canada",
              },
              new()
              {
                  ID = 6,
                  Name = "Switzerland",
              },

              new()
              {
                  ID = 7,
                  Name = "France",
              },
              new()
              {
                  ID = 8,
                  Name = "United States",
              },
              new()
              {
                  ID = 9,
                  Name = "Germany",
              },
              new()
              {
                  ID = 10,
                  Name = "Austria",
              });
        }
        private void SeedCities(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<City>().HasData(
                new()
                {
                    ID = 1,
                    Name = "Mostar",
                    ZipCode = "88000",
                    CountryId = 1,
                },
                new()
                {
                    ID = 2,
                    Name = "Sarajevo",
                    ZipCode = "77000",
                    CountryId = 1,
                },
                 new()
                 {
                     ID = 3,
                     Name = "Tuzla",
                     ZipCode = "75000",
                     CountryId = 1,
                 },
                new()
                {
                    ID = 4,
                    Name = "Zenica",
                    ZipCode = "72000",
                    CountryId = 1,
                },
                new()
                {
                    ID = 5,
                    Name = "Konjic",
                    ZipCode = "88400",
                    CountryId = 1,
                });
        }
        private void SeedLanguages(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Language>().HasData(
                new()
                {
                    ID = 1,
                    Name = "English",
                },
                new()
                {
                    ID = 2,
                    Name = "German",
                },
                new()
                {
                    ID = 3,
                    Name = "Bosnian",
                });
        }
        private void SeedUsers(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<User>().HasData(
                new User
                {
                    ID = 1,
                    FirstName = "Asmira",
                    LastName = "Husić",
                    Email = "admin@eCinema.com",
                    Role = Role.Administrator,
                    Gender = Gender.Female,
                    PasswordHash = "b4I5yA4Mp+0Pg1C3EsKU17sS13eDExGtBjjI07Vh/JM=", //Plain text: test
                    PasswordSalt = "1wQEjdSFeZttx6dlvEDjOg==",
                    PhoneNumber = "38761123456",
                    IsVerified = false,
                    IsActive = true,
                });
        }
        private void SeedProduction(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Production>().HasData(
               new()
               {
                   ID = 1,
                   Name = "Warner Bros",
                   CountryId = 6,
               },
               new()
               {
                   ID = 2,
                   Name = "Universal Pictures",
                   CountryId = 6,
               },
                new()
                {
                    ID = 3,
                    Name = "Režim",
                    CountryId = 3,
                },
               new()
               {
                   ID = 4,
                   Name = "Volcano Films",
                   CountryId = 6,
               });
        }
        private void SeedCinema(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Cinema>().HasData(
             new()
             {
                 ID = 1,
                 Name = "Cineplexx Plaza Mostar",
                 Address = "Bisce Polje bb",
                 Email = "plazamostar@gmail.com",
                 PhoneNumber = 060100100,
                 NumberOfHalls = 10,
                 CityId = 1,
             },
             new()
             {
                 ID = 2,
                 Name = "CineStar Sarajevo",
                 Address = "Dzemala Bijedica St",
                 Email = "srajevocinestar@gmail.com",
                 PhoneNumber = 060200200,
                 NumberOfHalls = 5,
                 CityId = 2,
             });
        }
        private void SeedGenre(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Genre>().HasData(
              new()
              {
                  ID = 1,
                  Name = "Action",
              },
              new()
              {
                  ID = 2,
                  Name = "Comedy",
              },
               new()
               {
                   ID = 3,
                   Name = "Horror",
               },
               new()
               {
                   ID = 4,
                   Name = "Romance",
               },
               new()
               {
                   ID = 5,
                   Name = "Western",
               },
               new()
               {
                   ID = 6,
                   Name = "Thriller",
               },
               new()
               {
                   ID = 7,
                   Name = "Drama",
               },
               new()
               {
                   ID = 8,
                   Name = "Mistery",
               });
        }
    }
}

