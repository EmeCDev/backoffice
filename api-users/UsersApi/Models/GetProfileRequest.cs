namespace UsersApi.Models
{
    public class GetProfileRequest
    {
        public int? ProfileId { get; set; }

        public GetProfileRequest() { }

        public GetProfileRequest(int profileId) 
        {
            ProfileId = profileId;
        }

        public override string ToString()
        {
            return $"Profile : {ProfileId}";
        }
    }
}
