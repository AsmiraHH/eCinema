
namespace eCinema.Core.DTOs
{
    public class MovieUpsertDTO
    {
        public int ID { get; set; }
        public string Title { get; set; } = null!;
        public string Description { get; set; } = null!;
        public string Author { get; set; } = null!;
        public int ReleaseYear { get; set; }
        public int Duration { get; set; }
        public string? PhotoBase64 { get; set; } = null!;
        public int LanguageId { get; set; }
        public int ProductionId { get; set; }
        public List<int> GenreIDs { get; set; }
    }
}
