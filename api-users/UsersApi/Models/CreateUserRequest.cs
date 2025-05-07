namespace UsersApi.Models
{
    public class CreateUserRequest
    {
        public string Name { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public int ProfileId { get; set; }

        public CreateUserRequest(string name, string email, string password, int profileId)
        {
            Name = name;
            Email = email;
            Password = password;
            ProfileId = profileId;
        }

        public override string ToString()
        {
            return $"Name : {Name}, Email : {Email}, ProfileId : {ProfileId}";
        }
    }
}