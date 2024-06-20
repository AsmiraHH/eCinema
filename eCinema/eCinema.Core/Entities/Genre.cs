namespace eCinema.Core.Entities
{
    public class Genre : BaseEntity
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;

        public ICollection<MovieGenre> Movies { get; set; } = null!;
    }
}
