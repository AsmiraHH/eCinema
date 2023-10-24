using eCinema.Core.Entities;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class EmployeeDTO
    {
        public string Title { get; set; } = null!;
        public int CinemaId { get; set; }
        public Cinema Cinema { get; set; } = null!;
    }
}
