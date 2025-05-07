namespace UsersApi.Models
{
    public class GetLogsRequest
    {
        public string? StartDate { get; set; }
        public string? EndDate { get; set; }
        public string? Email { get; set; }
        public string? ProcessName { get; set; }

        public GetLogsRequest(string? startDate = null, string? endDate = null, string? email = null, string? processName = null) 
        {
            StartDate = startDate;
            EndDate = endDate;
            Email = email;
            ProcessName = processName;
        }

        public GetLogsRequest() { }

        public override string ToString()
        {
            return $"Fecha Inicio: {StartDate}\nFecha Fin : {EndDate}\nUsuario: {Email}\nProceso: {ProcessName}";
        }
    }
}
