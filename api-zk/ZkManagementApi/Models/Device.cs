namespace ZkManagementApi.Models
{
    public class Device
    {
        public string? SerialNumber { get; set; }
        public string? Type { get; set; }
        public string? PushVersion { get; set; }
        public string? LastConnection { get; set; }
        public string? CompanyName { get; set; }
        public string? CompanyDatabase { get; set; }

        public Device(string? serialNumber, string? companyDatabase, string? companyName,
                     string? connectionDate, string? type, string? pushVersion)
        {
            SerialNumber = serialNumber;
            CompanyDatabase = companyDatabase;
            CompanyName = companyName;
            LastConnection = connectionDate;
            Type = type;
            PushVersion = pushVersion;
        }

        public Device() { }

        public override string ToString()
        {
            return $"Series: {SerialNumber ?? "null"}, " +
                   $"ClientDatabase: {CompanyDatabase ?? "null"}, " +
                   $"ClientName: {CompanyName ?? "null"}, " +
                   $"ConnectionDate: {LastConnection ?? "null"}, " +
                   $"Type: {Type ?? "null"}, " +
                   $"PushVersion: {PushVersion ?? "null"}";
        }
    }
}