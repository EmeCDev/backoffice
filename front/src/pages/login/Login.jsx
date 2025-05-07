import { useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";
import "./login.css";
import { toast } from "react-toastify";
import { PROTECTED_ROUTES, PUBLIC_ROUTES } from "../../routes";
import { fetchAuthenticate } from "../../api/usersApiRequest";
import emailIcon from '../../assets/icons/email.png';
import passwordIcon from '../../assets/icons/password.png';
import bannerImg from '../../assets/images/banner.png';

const Login = () => {
  useEffect(() => {
    sessionStorage.removeItem("userData");
  }, []);

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const navigate = useNavigate();

  const handleLogin = async (event) => {
    event.preventDefault();

    if (isLoading) return;

    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!regex.test(email)) {
      toast.warning("Ingrese un formato de correo valido.");
      return;
    }

    setIsLoading(true);

    fetchAuthenticate(email, password)
      .then(response => {
        toast.success(response.message);
        sessionStorage.setItem("userData", JSON.stringify(response.data));
        navigate(PROTECTED_ROUTES.CLIENT_DATA.FULL_PATH, { replace: true });
      })
      .catch(error => {
        handleLoginError(error);
      })
      .finally(() => {
        setIsLoading(false);
      });
  };

  const handleLoginError = (error) => {
    if (error.code === "ERR_NETWORK") {
      toast.error("No se pudo establecer conexión con la API de usuarios.");
      return;
    }

    if (!error.response?.data) {
      toast.error("Error desconocido.");
      return;
    }

    const { statusCode, message } = error.response.data;

    switch (statusCode) {
      case 401:
        toast.warning('Credenciales invalidas');
        break;
      case 400:
        toast.warning(message);
        break;
      case 500:
        toast.error(message);
        break;
      default:
        toast.error("Ocurrió un error inesperado");
    }
  };

  return (
    <div className="page-container full-size flex-row centered">
      <div className="login-container flex-column">
        <img
          src={bannerImg}
          alt="Genera Banner"
          className="banner"
        />

        <form onSubmit={handleLogin} className="login-content flex-column centered">
          <h1 className="login-header-tittle">Portal BackOffice</h1>

          <div className="input-container flex-row centered">
            <img src={emailIcon} alt="Email Icon" />
            <input
              className="mid-size"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="Correo"
              autoComplete="email"
              type="text"
              name="email"
              id="email"
              required
            />
          </div>

          <div className="input-container flex-row centered">
            <img src={passwordIcon} alt="Password Icon" />
            <input
              className="mid-size"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Contraseña"
              autoComplete="current-password"
              type="password"
              name="password"
              id="password"
              required
            />
          </div>

          <button
            type="submit"
            disabled={isLoading}
            className={isLoading ? "button-loading" : "button-active"}
          >
            {isLoading ? "Cargando..." : "Iniciar Sesión"}
          </button>
        </form>

        <div className="footer">Versión 2.0.0 (25-04-2025)</div>
      </div>
    </div>
  );
};

export default Login;