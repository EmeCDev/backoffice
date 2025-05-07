namespace ClientLicenseApi.Models
{
    public class ClientLicenseData
    {
        public string? ExpirationDate { get; set; }
        public string? WorkersCount { get; set; }
        public string? OldExpirationDate { get; set; }
        public string? OldWorkersCount { get; set; }

        public ClientLicenseData() { }

        public ClientLicenseData(string? expirationDate, string? workersCount) 
        {
            ExpirationDate = expirationDate;
            WorkersCount = workersCount;
        }

        public override string ToString()
        {
            return $"LicenseExpirationDate: {ExpirationDate ?? "Null"}, WorkersCount: {WorkersCount ?? "Null"}";
        }
    }
}
