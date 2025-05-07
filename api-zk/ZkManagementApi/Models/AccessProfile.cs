namespace ZkManagementApi.Models
{
    public class AccessProfile
    {
        public int? ID { get; set; }
        public string? Description { get; set; }

        public AccessProfile() 
        {

        }

        public AccessProfile(int? id, string? description)
        {
            ID = id;
            Description = description;
        }

        public override string ToString()
        {
            return $"ID: {ID}, Description: {Description}";
        }
    }
}
