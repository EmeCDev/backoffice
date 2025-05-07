namespace ClientLicenseApi.Models
{
    public class GetLicenseRequest
    {
        public int? Server { get; set; }
        public string? Database { get; set; }

        public GetLicenseRequest() { }

        public GetLicenseRequest(int? server, string? database) 
        {
            Server = server;
            Database = database;
        }

        public override string ToString()
        {
            return $"Server: {Server}, Database: {Database ?? "Null"}";
        }
    }
}
