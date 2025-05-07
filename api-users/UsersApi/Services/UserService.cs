using System.Runtime.InteropServices.ObjectiveC;
using System.Security.Authentication;
using System.Text.RegularExpressions;
using UsersApi.Helpers;
using UsersApi.Models;
using UsersApi.Repositories;

namespace UsersApi.Services
{
    public class UserService
    {

        private readonly UserRepository _userRepository;
        private readonly ProfileService _profileService;
        private readonly BcryptHelper _bcryptHelper;
        private readonly JwtHelper _jwtHelper;

        public UserService(UserRepository userRepository, BcryptHelper bcryptHelper, JwtHelper jwtHelper, ProfileService profileService) 
        {
            _userRepository = userRepository;
            _bcryptHelper = bcryptHelper;
            _jwtHelper = jwtHelper;
            _profileService = profileService;
        }

        public async Task<ApiResponse<User>> AuthenticateAsync(string email, string password)
        {
            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
                throw new ArgumentException("Debe indicar ambas credenciales.");

            string emailPattern = @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
            bool isValidEmail = Regex.IsMatch(email, emailPattern);

            if (!isValidEmail)
                throw new ArgumentException("Debe indicar un correo con formato valido.");

            string passwordHash = await _userRepository.GetPasswordByEmailAsync(email);

            if (string.IsNullOrWhiteSpace(passwordHash))
                throw new AuthenticationException("Credenciales invalidas.");

            bool validPassword = _bcryptHelper.ValidatePassword(password, passwordHash);

            if (!validPassword)
                throw new AuthenticationException("Credenciales invalidas.");

            User user = await _userRepository.GetUserByEmailAsync(email);

            user.Grants = await _profileService.GetGrantsByProfileAsync(user.ProfileId);

            if (!user.IsActive)
                throw new UnauthorizedAccessException("El usuario se encuentra inactivo.");

            return new ApiResponse<User>(true, 200, "Usuario autenticado", user);
        }

        public async Task<ApiResponse<bool>> LogoutAsync(string token)
        {
            if(!string.IsNullOrWhiteSpace(token))
            {
                await Task.Delay(20);
            }

            return new ApiResponse<bool>(true, 200, $"Cierre de sesión exitoso.", true); ;
        }

        public async Task<ApiResponse<List<UserDetails>>> GetAllUsersDetailsAsync(GetUserRequest getUserRequest)
        {
            List<UserDetails> users = await _userRepository.GetAllUsersDetailsAsync(getUserRequest);

            return new ApiResponse<List<UserDetails>>(true, 200, $"Se han encontrado {users.Count} usuario(s)", users);
        }

        public async Task<ApiResponse<User>> CreateUserAsync(CreateUserRequest user, int requestUser) 
        {
            if (string.IsNullOrWhiteSpace(user.Email) || string.IsNullOrWhiteSpace(user.Password) || string.IsNullOrWhiteSpace(user.Name))
                throw new ArgumentException("Debe indicar todos los datos requeridos para crear un usuario.");

            string emailPattern = @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
            bool isValidEmail = Regex.IsMatch(user.Email, emailPattern);

            if (!isValidEmail)
                throw new ArgumentException("Debe indicar un correo con formato valido.");

            if (user.ProfileId <= 0)
                throw new ArgumentException("Debe indicar un ID de perfil valido.");

            string passwordPattern = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$";
            bool isValidPassword =  Regex.IsMatch(user.Password, passwordPattern);

            if (!isValidPassword)
                throw new ArgumentException("La contraseña debe " +
                                                        "tener al menos 8 caracteres, " +
                                                        "incluir una letra mayúscula, " +
                                                        "una letra minúscula y un número.");

            user.Password = _bcryptHelper.HashPassword(user.Password);

            int createdUserId = await _userRepository.CreateUserAsync(user, requestUser);

            if (createdUserId == -1)
                throw new ArgumentException("Error al crear el usuario");

            User createdUser = new (createdUserId, user.Name, user.Email, user.ProfileId, new List<int>(), true);

            createdUser.Grants = await _profileService.GetGrantsByProfileAsync(user.ProfileId);

            return new ApiResponse<User>(true, 201, "Usuario creado exitosamente.", createdUser);
        }

        public async Task<ApiResponse<User>> UpdateUserAsync(UpdateUserRequest user, int requestUser)
        {
            if (user == null)
                throw new ArgumentException("Debe proporcionar un usuario válido para actualizar.");

            if (string.IsNullOrWhiteSpace(user.Email))
            {
                user.Email = null;
            }
            else
            {
                string emailPattern = @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
                if (!Regex.IsMatch(user.Email, emailPattern))
                    throw new ArgumentException("Debe indicar un correo con formato válido.");
            }

            if (string.IsNullOrWhiteSpace(user.Name))
            {
                throw new ArgumentException("Debe indicar un nombre para el usuario.");
            }

            
            if (user.ProfileId <= 0)
            {
                throw new ArgumentException("Debe indicar un ID de perfil válido.");
            }

            if (string.IsNullOrWhiteSpace(user.Password))
            {
                user.Password = null;
            }
            else
            {
                string passwordPattern = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$";
                if (!Regex.IsMatch(user.Password, passwordPattern))
                    throw new ArgumentException("La contraseña debe " +
                                                "tener al menos 8 caracteres, " +
                                                "incluir una letra mayúscula, " +
                                                "una letra minúscula y un número.");

                user.Password = _bcryptHelper.HashPassword(user.Password);
            }

            var updatedUser = await _userRepository.UpdateUserAsync(user, requestUser);

            if (updatedUser == null)
                throw new ArgumentException("Error al modificar el usuario.");

            updatedUser.Grants = await _profileService.GetGrantsByProfileAsync(updatedUser.ProfileId);

            return new ApiResponse<User>(true, 200, "Usuario actualizado exitosamente.", updatedUser);
        }



        public string GetJwtToken(User user)
        {
            string token = _jwtHelper.GenerateJwt(user.Id, user.Grants);
            return token;
        }
    }
}
