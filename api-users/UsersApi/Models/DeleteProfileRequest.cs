namespace UsersApi.Models
{
    public class DeleteProfileRequest
    {
        public int? ProfileId { get; set; }

        public DeleteProfileRequest(int? profileId)
        {
            ProfileId = profileId;
        }

        public DeleteProfileRequest() { }

        public override string ToString()
        {
            return $"ProfileId : {ProfileId}";
        }
    }
}
