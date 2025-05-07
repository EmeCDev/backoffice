namespace ZkManagementApi.Models
{
    public class GetCompanyRequest
    {
        public int? ServerId { get; set; }
        public string? CompanyName { get; set; }

        public GetCompanyRequest(int? serverId = null, string? companyName = null)
        {
            ServerId = serverId;
            CompanyName = companyName;
        }

        public GetCompanyRequest() { }

        public override string ToString()
        {
            return $"ServerId: {(ServerId.HasValue ? ServerId.Value.ToString() : "null")}, " +
                   $"CompanyName: {CompanyName ?? "null"}";
        }
    }
}