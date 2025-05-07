import { Navigate, Outlet, useNavigate } from "react-router-dom";
import { PUBLIC_ROUTES } from "../routes";

const AuthGuard = () => {

    const navigate = useNavigate();

    const userData = JSON.parse(sessionStorage.getItem("userData"));
    
    const isAuthenticated = userData && userData.email;

    return isAuthenticated ? <Outlet /> : <Navigate replace to={PUBLIC_ROUTES.LOGIN.FULL_PATH} />;
}

export default AuthGuard;