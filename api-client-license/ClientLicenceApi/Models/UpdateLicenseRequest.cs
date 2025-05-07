using System.Globalization;

namespace ClientLicenseApi.Models
{
    public class UpdateLicenseRequest
    {
        public int? Server { get; set; }
        public string? Database { get; set; }
        public string? NewExpirationDate { get; set; }
        public string? OldExpirationDate { get; set; }
        public string? NewWorkersCount { get; set; }
        public string? OldWorkersCount { get; set; }

        public UpdateLicenseRequest() { }

        public UpdateLicenseRequest(int? server, string? database, string? newExpirationDate, string? newWorkersCount, string? oldExpirationDate, string? oldWorkersCount) 
        {
            Server = server;
            Database = database;
            NewExpirationDate = newExpirationDate;
            NewWorkersCount = newWorkersCount;
            OldExpirationDate = oldExpirationDate;
            OldWorkersCount = oldWorkersCount;
        }

        public override string ToString()
        {
            return $"Servidor: {Server} \n" +
                   $"Cliente: {Database ?? "Null"}\n" +
                   $"Expiración Antigua: {OldExpirationDate ?? "Null"}\n" +
                   $"Cantidad Trabajadores Antigua: {OldWorkersCount ?? "Null"}\n" +
                   $"Expiración Nueva: {FormatDate(NewExpirationDate ?? string.Empty)}\n" +
                   $"Cantidad Trabajadores Nueva: {NewWorkersCount ?? "Null"}";
        }

        private string FormatDate(string yyyymmddDate)
        {
            if (string.IsNullOrWhiteSpace(yyyymmddDate) || yyyymmddDate.Length != 8)
                return "Null";

            return $"{yyyymmddDate.Substring(6, 2)}-{yyyymmddDate.Substring(4, 2)}-{yyyymmddDate.Substring(0, 4)}";
        }
    }
}