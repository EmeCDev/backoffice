namespace UsersApi.Models
{
    public class AuthenticationRequest
    {
        public string Email { get; set; }
        public string Password { get; set; }

        public AuthenticationRequest(string email, string password)
        {
            Email = email;
            Password = password;
        }

        public override string ToString()
        {
            return $"Email' : {Email}";
        }
    }
}