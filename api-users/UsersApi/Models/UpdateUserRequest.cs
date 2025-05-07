namespace UsersApi.Models
{
    public class UpdateUserRequest
    {
        public int UserId { get; set; } 
        public string Name { get; set; }
        public string Email { get; set; }
        public string? Password { get; set; }
        public bool IsActive { get; set; }
        public int ProfileId { get; set; }

        public UpdateUserRequest(int userId, string name, string email, string password, bool isActive, int profileId)
        {
            UserId = userId;
            Name = name;
            Email = email;
            Password = password;
            IsActive = isActive;
            ProfileId = profileId;
        }

        public override string ToString()
        {
            return $"UserId : {UserId}, Name : {Name}, Email : {Email}, IsActive : {IsActive}, ProfileId' : {ProfileId}";
        }
    }
}