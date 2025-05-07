namespace ZkManagementApi.Models
{
    public class SendProfileRequest
    {
        public int? Server { get; set; }
        public string? Database { get; set; }
        public int? ProfileId { get; set; }

        public SendProfileRequest(int? server = null, string? database = null, int? profileId = null)
        {
            Server = server;
            Database = database;
            ProfileId = profileId;
        }

        public SendProfileRequest() { }

        public override string ToString()
        {
            return $"ServerId: {(Server.HasValue ? Server.Value.ToString() : "null")}, " +
                   $"Database: {Database ?? "null"}, " +
                   $"ProfileId: {(ProfileId.HasValue ? ProfileId.Value.ToString() : "null")}";
        }
    }
}
