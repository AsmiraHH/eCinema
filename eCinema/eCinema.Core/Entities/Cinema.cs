using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.Entities
{
    public class Cinema : BaseEntity
    {
        public int ID { get; set; }
        public string Name { get; set; } = null!;
        public string Address { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string PhoneNumber { get; set; } = null!;
        public int NumberOfHalls { get; set; }

        [ForeignKey(nameof(City))]
        public int CityId { get; set; }
        public City City { get; set; } = null!;

        public ICollection<Hall> Halls { get; set; } = null!;
        public ICollection<Employee> Employees { get; set; } = null!;
        //public ICollection<Show> Shows { get; set; } = null!;
    }
}
