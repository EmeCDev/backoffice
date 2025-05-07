namespace UsersApi.Models
{
    public class UpdateProfileRequest
    {
        public int? ProfileId { get; set; }
        public string? Name { get; set; }
        public List<int>? GrantsList { get; set; }

        public UpdateProfileRequest(int? profileId, string? name, List<int>? grantsList)
        {
            ProfileId = profileId;
            Name = name;
            GrantsList = grantsList;
        }

        public UpdateProfileRequest() { }

        public override string ToString()
        {
            return $"ProfileId : {ProfileId}, Name : {Name}, GrantList = [{string.Join(",", GrantsList ?? new List<int>())}]";
        }

        public string GrantsListToString()
        {
            return string.Join(",", GrantsList ?? new List<int>());
        }
    }
}
