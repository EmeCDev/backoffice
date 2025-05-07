import { Navigate, Outlet, useNavigate } from "react-router-dom";
import { PROTECTED_ROUTES } from "../routes";
import PropTypes from "prop-types";

const GrantGuard = ({ requiredGrant }) => {

    const navigate = useNavigate();

    let parsedData = {};
    try {
        parsedData = JSON.parse(sessionStorage.getItem("userData")) || {};
    } catch (error) {
        console.error("Error parsing userData:", error);
    }

    const userGrants = parsedData?.grants ?? [];

    const hasGrant = userGrants.includes(requiredGrant);

    return hasGrant ? (
        <Outlet />
    ) : (
        <Navigate replace to={PROTECTED_ROUTES.HOME.FULL_PATH} />
    );
};

GrantGuard.propTypes = {
    requiredGrant: PropTypes.number.isRequired
};

export default GrantGuard;