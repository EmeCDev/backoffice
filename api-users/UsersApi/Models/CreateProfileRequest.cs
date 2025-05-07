namespace UsersApi.Models
{
    public class CreateProfileRequest
    {
        public string? Name { get; set; }
        public List<int>? GrantsList { get; set; }

        public CreateProfileRequest(string? name, List<int>? grantsList)
        {
            Name = name;
            GrantsList = grantsList;
        }

        public CreateProfileRequest() { }

        public override string ToString()
        {
            return $"Name : {Name}, GrantList = [{GrantsListToString()}]";
        }

        public string GrantsListToString() 
        {
            return string.Join(",", GrantsList ?? new List<int>());
        }
    }
}
