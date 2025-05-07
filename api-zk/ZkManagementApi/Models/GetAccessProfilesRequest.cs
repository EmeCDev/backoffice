namespace ZkManagementApi.Models
{
    public class GetAccessProfilesRequest
    {
        public int? Server { get; set; }
        public string? Database { get; set; }

        public GetAccessProfilesRequest(int? server, string? database) 
        {
            Server = server; 
            Database = database;
        }

        public GetAccessProfilesRequest() { }

        public override string ToString()
        {
            return $"Server: {Server}, Database: {Database}";
        }
    }
}
