using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class CityUpsertDTO
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;
        public string ZipCode { get; set; } = null!;
        public int CountryId { get; set; }
    }
}
