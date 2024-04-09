using eCinema.Core.Entities;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class MovieGenreDTO
    {
        public int MovieId { get; set; }
        public MovieDTO Movie { get; set; } = null!;

        public int GenreId { get; set; }
        public GenreDTO Genre { get; set; } = null!;
    }
}
