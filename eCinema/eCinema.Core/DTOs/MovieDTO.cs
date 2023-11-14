using eCinema.Core.Entities;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class MovieDTO
    {
        public int ID { get; set; }
        public string Title { get; set; } = null!;
        public string Description { get; set; } = null!;
        public string Author { get; set; } = null!;
        public int ReleaseYear { get; set; }
        public int Duration { get; set; }
        public byte[]? Photo { get; set; } = null!;
        public int LanguageId { get; set; }
        public Language Language { get; set; } = null!;
        public int ProductionId { get; set; }
        public Production Production { get; set; } = null!;
        public int MovieGenreId { get; set; }
        public MovieGenreDTO MovieGenre { get; set; } = null!;
    }
}
