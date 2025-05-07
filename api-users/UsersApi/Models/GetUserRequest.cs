namespace UsersApi.Models
{
    public class GetUserRequest
    {
        public string? Name { get; set; }
        public string? Email { get; set; }
        public bool? IsActive { get; set; }

        public GetUserRequest() { }

        public override string ToString()
        {
            return $"Name : {Name}, Email : {Email}, IsActive : {IsActive}";
        }
    }
}
