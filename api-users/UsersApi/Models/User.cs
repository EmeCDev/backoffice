namespace UsersApi.Models
{
    public class User
    {
        public int Id { get; set; }
        public string? Name { get; set; }
        public string? Email { get; set; }
        public int ProfileId { get; set; }
        public string? ProfileName { get; set; }
        public List<int>? Grants { get; set; }
        public bool IsActive { get; set; }

        public User(int id, string name, string email, int profileId, List<int> grants, bool isActive)
        {
            Id = id;
            Name = name;
            Email = email;
            ProfileId = profileId;
            Grants = grants;
            IsActive = isActive;
        }

        public override string ToString()
        {
            var grantsString = Grants != null ? string.Join(", ", Grants) : "[]";
            return $"{{'Id' : '{Id}', 'Name' : '{Name}', 'Email' : '{Email}', 'ProfileId' : '{ProfileId}', 'Grants' : [{grantsString}], 'IsActive' : '{IsActive}'}}";
        }
    }
}