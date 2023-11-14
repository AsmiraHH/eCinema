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
        public int LanguageId { get; set; }
        public Language Language { get; set; } = null!;

        [ForeignKey(nameof(Production))]
        public int ProductionId { get; set; }
        public Production Production { get; set; } = null!;

        public ICollection<MovieGenre> MovieGenres { get; set; } = null!;
        public ICollection<MovieActor> MovieActors { get; set; } = null!;
        public ICollection<Show> Shows { get; set; } = null!;
    }
}
