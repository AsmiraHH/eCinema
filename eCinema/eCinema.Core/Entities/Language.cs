namespace eCinema.Core.Entities
{
    public class Language : BaseEntity
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;

        public virtual ICollection<Movie> Movies { get; set; } = null!;
    }
}
