using eCinema.Core.Enums;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Reflection;

namespace eCinema.Core.DTOs
{
    public class UserUpsertImageDTO
    {
        public int ID { get; set; }
        public string PhotoBase64 { get; set; } = null!;
    }
}
