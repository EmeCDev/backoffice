namespace ZkManagementApi.Models
{
    public class NewDeviceInfo
    {
        public string? Description { get; set; }
        public string? Location { get; set; }
        public string? Model { get; set; }
        public string? Function { get; set; }
        public string? SerialNumber { get; set; }
        public string? Active { get; set; }
        public string? LastConnectionDate { get; set; }
        public int? DisconnectionTime { get; set; }

        public NewDeviceInfo()
        {
        }

        public NewDeviceInfo(
            string? description = null,
            string? location = null,
            string? model = null,
            string? function = null,
            string? serialNumber = null,
            string? active = null,
            string? lastConnectionDate = null,
            int? disconnectionTime = null)
        {
            Description = description;
            Location = location;
            Model = model;
            Function = function;
            SerialNumber = serialNumber;
            Active = active;
            LastConnectionDate = lastConnectionDate;
            DisconnectionTime = disconnectionTime;
        }

        public override string ToString()
        {
            return base.ToString();
        }
    }
}