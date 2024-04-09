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
        public  LanguageDTO Language { get; set; } = null!;
        public ProductionDTO Production { get; set; } = null!;
        public List<MovieGenreDTO> Genres { get; set; } = null!;
    }
}
