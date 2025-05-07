namespace ZkManagementApi.Models
{
    public class GetCompanyInfoRequest
    {
        public int? CompanyRut { get; set; }
        public string? CompanyName { get; set; }
        public bool? IsVisible { get; set; }

        public GetCompanyInfoRequest()
        {
        }

        public GetCompanyInfoRequest(int? companyRut = null, string? companyName = null, bool? isVisible = null)
        {
            CompanyRut = companyRut;
            CompanyName = companyName;
            IsVisible = isVisible;
        }

        public override string ToString()
        {
            return $"CompanyRut: {(CompanyRut.HasValue ? CompanyRut.Value.ToString() : "null")}, " +
                   $"CompanyName: {CompanyName ?? "null"}";
        }
    }
}