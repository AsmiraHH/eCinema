using eCinema.Core.DTOs;

namespace eCinema.Core.Helpers
{
    public class ReportModel
    {
        public double TotalPrice { get; set; }
        public int TotalCount { get; set; }
        public int TotalUsers { get; set; }
        public List<ReservationDTO> ListOfReservations { get; set; } = null!;
    }
}
