namespace ZkManagementApi.Models
{
    public class UpdateVisibilityRequest
    {
        public int? CompanyRut { get; set; }
        public bool? VisibleGeneral { get; set; }
        public bool? VisibleZK { get; set; }
        public bool? VisibleDT { get; set; }

        public UpdateVisibilityRequest() { }

        public UpdateVisibilityRequest(int? companyRut = null, bool? visibleGeneral = null, bool? visibleZK = null, bool? visibleDT = null)
        {
            CompanyRut = companyRut;
            VisibleGeneral = visibleGeneral;
            VisibleZK = visibleZK;
            VisibleDT = visibleDT;
        }

        public override string ToString()
        {
            return $"RUT Empresa: {CompanyRut}, General: {VisibleGeneral}, ZK: {VisibleZK}, DT: {VisibleDT}";
        }
    }
}
