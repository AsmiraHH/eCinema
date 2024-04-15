using eCinema.Core.Enums;

namespace eCinema.Core.SearchObjects
{
    public class EmployeeSearchObject : BaseSearchObject
    {
        public string? Name{ get; set; }
        public int? Cinema{ get; set; }
        public Gender? Gender{ get; set; }
        public bool? isActive{ get; set; }
    }
}
