using UsersApi.Models;
using UsersApi.Repositories;

namespace UsersApi.Services
{
    public class ProfileService
    {
        private readonly ProfileRepository _profileRepository;

        public ProfileService(ProfileRepository profileRepository)
        {
            _profileRepository = profileRepository;
        }

        public async Task<ApiResponse<List<Profile>>> GetAllProfilesAsync()
        {
            List<Profile> profiles = await _profileRepository.GetAllProfilesAsync();
            return new ApiResponse<List<Profile>>(true, 200, $"Se han encontrado {profiles.Count} perfil(es)", profiles);
        }

        public async Task<List<int>> GetGrantsByProfileAsync(int profileId)
        {
            List<int> grants = await _profileRepository.GetGrantsByProfileAsync(profileId);
            return grants;
        }

        public async Task<ApiResponse<int>> CreateProfileAsync(CreateProfileRequest createProfileRequest, int createdBy)  
        {
            if (createProfileRequest.Name is null)
                throw new ArgumentException("Debe indicar un Name valido");

            if (createProfileRequest.GrantsList is null || createProfileRequest.GrantsList.Count <= 0)
                throw new ArgumentException("Debe indicar los Grants asociados al perfil");

            int createdProfileId = await _profileRepository.CreateProfileAsync(createProfileRequest, createdBy);

            if (createdProfileId == -1)
                throw new ArgumentException("Error al crear el perfil");

            return new ApiResponse<int>(true, 200, "Se ha creado el perfil exitosamente.", createdProfileId);
        }

        public async Task<ApiResponse<int>> UpdateProfileAsync(UpdateProfileRequest updateProfileRequest, int createdBy)
        {
            if (updateProfileRequest.ProfileId is null)
                throw new ArgumentException("Debe indicar un ProfileId valido");

            if (updateProfileRequest.Name is null)
                throw new ArgumentException("Debe indicar un Name valido");

            if (updateProfileRequest.GrantsList is null || updateProfileRequest.GrantsList.Count <= 0)
                throw new ArgumentException("Debe indicar los Grants asociados al perfil");

            bool isProfileUpdated = await _profileRepository.UpdateProfileAsync(updateProfileRequest, createdBy);

            if (!isProfileUpdated)
                throw new ArgumentException("Error al crear el perfil");

            return new ApiResponse<int>(true, 200, "Se ha modificado el perfil exitosamente.");
        }

        public async Task<ApiResponse<int>> DeleteProfileAsync(DeleteProfileRequest deleteProfileRequest)
        {
            if (deleteProfileRequest.ProfileId is null)
                throw new ArgumentException("Debe indicar un ProfileId valido");

            bool isProfileDeleted = await _profileRepository.DeleteProfileAsync(deleteProfileRequest);

            if (!isProfileDeleted)
                throw new ArgumentException("Error al eliminar el perfil");

            return new ApiResponse<int>(true, 200, "Se ha eliminado el perfil exitosamente.");
        }

        public async Task<ApiResponse<Profile>> GetProfileAsync(GetProfileRequest getProfileRequest)
        {
            if (getProfileRequest.ProfileId is null)
                throw new ArgumentException("Debe indicar un ProfileId valido");

            Profile profile = await _profileRepository.GetProfileAsync(getProfileRequest);

            if (profile is null)
                throw new ArgumentException("No se ha encontrado el perfil solicitado.");
            

            profile.Grants = await _profileRepository.GetGrantsByProfileAsync(getProfileRequest.ProfileId);

            return new ApiResponse<Profile>(true, 200, "Se ha encontrado el perfil solicitado.", profile);

        }
    }
}
