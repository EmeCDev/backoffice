namespace UsersApi.Models
{
    public class UserDetails
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string ProfileName { get; set; }
        public int ProfileId { get; set; }
        public bool IsActive { get; set; }

        public UserDetails(int id, string name, string email, string profileName, int profileId, bool isActive)
        {
            Id = id;
            Name = name;
            Email = email;
            ProfileName = profileName;
            ProfileId = profileId;
            IsActive = isActive;
        }

        public override string ToString()
        {
            return $"{{'Id' : '{Id}', 'Name' : '{Name}', 'Email' : '{Email}', 'Profile' : '{ProfileName}', 'IsActive' : '{IsActive}'}}";
        }
    }
}