namespace eCinema.Core.Entities
{
    public class Country
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;

        public ICollection<City> Cities { get; set; } = null!;
        public ICollection<Production> Productions { get; set; } = null!;
    }
}
