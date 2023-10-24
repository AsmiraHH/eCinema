using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class CinemaUpsertDTO
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;
        public string Address { get; set; } = null!;
        public string Email { get; set; } = null!;
        public int PhoneNumber { get; set; }
        public int NumberOfHalls { get; set; }
        public int CityId { get; set; }
    }
}
