namespace UsersApi.Models
{
    public class Profile
    {
        public int? ProfileId { get; set; }
        public string? Name { get; set; }
        public bool? IsActive { get; set; }
        public List<int>? Grants { get; set; }


        public Profile(int profileId, string name, bool isActive, List<int>? grants = null)
        {
            ProfileId = profileId;
            Name = name;
            IsActive = isActive;
            Grants = grants;
        }

        public Profile() {}

        public override string ToString()
        {
            return $"Profile Id : {ProfileId}, Name : {Name}, IsActive : {IsActive}";
        }
    }
}