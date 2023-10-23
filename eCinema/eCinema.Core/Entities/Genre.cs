namespace eCinema.Core.Entities
{
    public class Genre
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;

        public ICollection<MovieGenre> MovieGenres { get; set; } = null!;
    }
}
