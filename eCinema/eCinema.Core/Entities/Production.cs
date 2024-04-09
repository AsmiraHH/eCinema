using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.Entities
{
    public class Production
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;

        [ForeignKey(nameof(Country))]
        public int CountryId { get; set; }
        public virtual Country Country { get; set; } = null!;

        public virtual ICollection<Movie> Movies { get; set; } = null!;
    }
}
