using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.Entities
{
    public class Movie
    {
        public int ID { get; set; }
        public string Title { get; set; } = null!;
        public string Description { get; set; } = null!;
        public string Author { get; set; } = null!;
        public int ReleaseYear { get; set; }
        public int Duration { get; set; }
        public byte[]? Photo { get; set; } = null!;

        [ForeignKey(nameof(Language))]
        public int? LanguageId { get; set; }
        public Language? Language { get; set; } 

        [ForeignKey(nameof(Production))]
        public int? ProductionId { get; set; }
        public Production? Production { get; set; } 

        public ICollection<MovieGenre> Genres { get; set; } = new List<MovieGenre>();
        public ICollection<MovieActor> Actors { get; set; } = new List<MovieActor>();
        public ICollection<Show> Shows { get; set; } = null!;
    }
}
