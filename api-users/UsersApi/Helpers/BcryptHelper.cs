namespace UsersApi.Helpers
{
    public class BcryptHelper
    {
        public string HashPassword(string password)
        {
            int workFactor = 10;
            return BCrypt.Net.BCrypt.HashPassword(password, workFactor);
        }

        public bool ValidatePassword(string password, string storedHash)
        {
            return BCrypt.Net.BCrypt.Verify(password, storedHash);
        }
    }
}
