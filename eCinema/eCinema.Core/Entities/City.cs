using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.Entities
{
    public class City : BaseEntity
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;
        public string ZipCode { get; set; } = null!;

        [ForeignKey(nameof(Country))]
        public int CountryId { get; set; }
        public Country Country { get; set; } = null!;

        public ICollection<Cinema> Cinemas { get; set; } = null!;
    }
}
