using eCinema.Core.Enums;

namespace eCinema.Core.SearchObjects
{
    public class UserSearchObject : BaseSearchObject
    {
        public string? Name{ get; set; }
        public Gender? Gender{ get; set; }
        public bool? isActive{ get; set; }
        public bool? isVerified{ get; set; }
    }
}
