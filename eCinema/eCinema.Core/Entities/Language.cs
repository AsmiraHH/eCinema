namespace eCinema.Core.Entities
{
    public class Language
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;

        public virtual ICollection<Movie> Movies { get; set; } = null!;
    }
}
