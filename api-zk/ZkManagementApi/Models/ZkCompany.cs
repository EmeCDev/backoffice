namespace ZkManagementApi.Models
{
    public class ZkCompany
    {
        public int? CompanyId { get; set; }
        public string? Client { get; set; }
        public string? DatabaseName { get; set; }
        public string? EntryDate { get; set; }
        public int? IsActive { get; set; }

        public ZkCompany(int? companyId, string? client, string? databaseName, string? entryDate, int? isActive)
        {
            CompanyId = companyId;
            Client = client;
            DatabaseName = databaseName;
            EntryDate = entryDate;
            IsActive = isActive;
        }

        public ZkCompany() { }

        public override string ToString()
        {
            return $"CompanyId: {(CompanyId.HasValue ? CompanyId.Value.ToString() : "null")}, " +
                   $"Client: {Client ?? "null"}, " +
                   $"DatabaseName: {DatabaseName ?? "null"}, " +
                   $"EntryDate: {EntryDate ?? "null"}, " +
                   $"IsActive: {(IsActive.HasValue ? IsActive.Value.ToString() : "null")}";
        }
    }
}