using eCinema.Core.Entities;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class CityDTO
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;
        public string ZipCode { get; set; } = null!;
        public CountryDTO Country { get; set; } = null!;
    }
}
