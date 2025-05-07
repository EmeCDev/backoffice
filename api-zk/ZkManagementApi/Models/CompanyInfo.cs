namespace ZkManagementApi.Models
{
    public class CompanyInfo
    {
        public int Id { get; set; }
        public string Servidor { get; set; }
        public string BdGenhoras { get; set; }
        public string NombreEmpresa { get; set; }
        public string RutEmpresa { get; set; }
        public string Dv { get; set; }
        public string TipoCliente { get; set; }
        public string UrlCliente { get; set; }

        public CompanyInfo()
        {
        }

        public CompanyInfo(int id, string servidor, string bdGenhoras, string nombreEmpresa,
                         string rutEmpresa, string dv, string tipoCliente, string urlCliente)
        {
            Id = id;
            Servidor = servidor;
            BdGenhoras = bdGenhoras;
            NombreEmpresa = nombreEmpresa;
            RutEmpresa = rutEmpresa;
            Dv = dv;
            TipoCliente = tipoCliente;
            UrlCliente = urlCliente;
        }

        public override string ToString()
        {
            return $"Id: {Id}, " +
                   $"Servidor: {Servidor ?? "null"}, " +
                   $"BdGenhoras: {BdGenhoras ?? "null"}, " +
                   $"NombreEmpresa: {NombreEmpresa ?? "null"}, " +
                   $"RUT: {(RutEmpresa != null ? $"{RutEmpresa}-{Dv ?? "null"}" : "null")}, " +
                   $"TipoCliente: {TipoCliente ?? "null"}, " +
                   $"UrlCliente: {UrlCliente ?? "null"}";
        }
    }
}