namespace ZkManagementApi.Models
{
    public class GetDeviceRequest
    {
        public int? Server { get; set; }
        public string? Database { get; set; }
        public string? SerialNumber { get; set; }

        public GetDeviceRequest(int? server = null, string? database = null, string? serialNumber = null)
        {
            Server = server;
            Database = database;
            SerialNumber = serialNumber;
        }

        public GetDeviceRequest() { }

        public override string ToString()
        {
            return $"ServerId: {(Server.HasValue ? Server.Value.ToString() : "null")}, " +
                   $"Database: {Database ?? "null"}, " +
                   $"SerialNumber: {SerialNumber ?? "null"}, ";
        }
    }
}