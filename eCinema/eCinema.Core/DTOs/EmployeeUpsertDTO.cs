using eCinema.Core.Entities;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Core.DTOs
{
    public class EmployeeUpsertDTO
    {
        public string Title { get; set; } = null!;
        public int CinemaId { get; set; }
    }
}
