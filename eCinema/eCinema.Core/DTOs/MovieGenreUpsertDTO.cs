using eCinema.Core.Entities;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class MovieGenreUpsertDTO
    {
        public int MovieId { get; set; }

        public int GenreId { get; set; }
    }
}
