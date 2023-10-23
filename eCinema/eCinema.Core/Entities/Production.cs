using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.Entities
{
    public class Production
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;

        [ForeignKey(nameof(Country))]
        public int CountryId { get; set; }
        public Country Country { get; set; } = null!;

        public ICollection<Movie> Movies { get; set; } = null!;
    }
}
