import { useNavigate } from 'react-router-dom';
import { PROTECTED_ROUTES, PUBLIC_ROUTES } from '../../routes.js';
import { useEffect, useState } from 'react';
import './styles/navbar.css';
import bannerImg from '../../assets/images/banner.png';
import logoutIcon from '../../assets/icons/logout.png';
import sendUserIcon from '../../assets/icons/send-user.png';
import clientsIcon from '../../assets/icons/companies.png';
import bulkUploadIcon from '../../assets/icons/bulk-upload.png';
import usersIcon from '../../assets/icons/users.png';
import profilesIcon from '../../assets/icons/profiles.png';
import logsIcon from '../../assets/icons/logs.png';
import { toast } from 'react-toastify';
import { fetchLogout } from '../../api/usersApiRequest.js';

const Navbar = () => {
    const navigate = useNavigate();

    // Usamos useState para almacenar los grants del usuario
    const [userGrants, setUserGrants] = useState([]);
    const [hasZkGrants, setHasZkGrants] = useState(false);
    const [hasConfigurationGrants, setHasConfigurationGrants] = useState(false);
    const [hasClientGrants, setHasClientGrants] = useState(false);

    // Grants
    const zkGrants = [500, 501];
    const configurationGrants = [201, 301, 304, 800];
    const clientGrants = [200];

    useEffect(() => {
        const userData = sessionStorage.getItem("userData");
        const grants = userData ? JSON.parse(userData).grants : [];
        setUserGrants(grants);
    }, []);

    useEffect(() => {
        if (userGrants.length > 0) {
            if (zkGrants.some(grant => userGrants.includes(grant))) {
                setHasZkGrants(true);
            }
            else {
                setHasZkGrants(false);
            }

            if (configurationGrants.some(grant => userGrants.includes(grant))) {
                setHasConfigurationGrants(true);
            }
            else {
                setHasConfigurationGrants(false);
            }

            if (clientGrants.some(grant => userGrants.includes(grant))) {
                setHasClientGrants(true);
            }
            else {
                setHasClientGrants(false);
            }
        }
    }, [userGrants]);

    const handleLogout = (e) => {
        e.preventDefault();

        fetchLogout()
            .then(() => {
                toast.success('Sesión cerrada');
            })
            .catch((error) => {
                console.log(error);
            })
            .finally(() => {
                navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
            });
    };

    return (
        <div className="navbar-container flex-column">
            <img src={bannerImg} alt="Genera Banner" className="nav-banner" onClick={() => navigate(PROTECTED_ROUTES.CLIENT_DATA.FULL_PATH, { replace: true })} />

            {clientGrants && (
                <div className="navbar-section flex-column">
                    <h2 className="section-tittle"> Inicio </h2>
                    {userGrants.includes(200) && (
                        <div className="nav-item flex-row" onClick={() => { navigate(PROTECTED_ROUTES.CLIENT_DATA.FULL_PATH, { replace: true }) }}>
                            <img src={clientsIcon} alt="Enviar Usuario Icon" className='nav-item-icon' />
                            <span className='nav-item-name'> Clientes</span>
                        </div>
                    )}
                </div>
            )}

            {hasZkGrants && (
                <div className="navbar-section flex-column">
                    <h2 className="section-tittle"> Gestión ZK general</h2>
                    {userGrants.includes(500) && (
                        <div className="nav-item flex-row" onClick={() => { navigate(PROTECTED_ROUTES.ZK_SEND_USER.FULL_PATH, { replace: true }) }}>
                            <img src={sendUserIcon} alt="Enviar Usuario Icon" className='nav-item-icon' />
                            <span className='nav-item-name'> Carga Administrador </span>
                        </div>
                    )}


                    {userGrants.includes(501) && (
                        <div className="nav-item flex-row" onClick={() => { navigate(PROTECTED_ROUTES.ZK_BULK_ACCESS_UPLOAD.FULL_PATH, { replace: true }) }}>
                            <img src={bulkUploadIcon} alt="Enviar Usuario Icon" className='nav-item-icon' />
                            <span className='nav-item-name'> Carga Masiva Accesos </span>
                        </div>
                    )}
                </div>
            )}

            {hasZkGrants && (
                <div className="navbar-section flex-column">
                    <h2 className="section-tittle"> Gestión ZK Arcos Dorados</h2>
                    {userGrants.includes(500) && (
                        <div className="nav-item flex-row" onClick={() => { navigate(PROTECTED_ROUTES.ZK_SEND_USER_AD.FULL_PATH, { replace: true }) }}>
                            <img src={sendUserIcon} alt="Enviar Usuario Icon" className='nav-item-icon' />
                            <span className='nav-item-name'> Carga Administrador </span>
                        </div>
                    )}


                    {userGrants.includes(501) && (
                        <div className="nav-item flex-row" onClick={() => { navigate(PROTECTED_ROUTES.ZK_BULK_ACCESS_UPLOAD_AD.FULL_PATH, { replace: true }) }}>
                            <img src={bulkUploadIcon} alt="Enviar Usuario Icon" className='nav-item-icon' />
                            <span className='nav-item-name'> Carga Masiva Accesos </span>
                        </div>
                    )}
                </div>
            )}

            {hasZkGrants && (
                <div className="navbar-section flex-column">
                    <h2 className="section-tittle"> Gestión ZK Ripley</h2>
                    {userGrants.includes(500) && (
                        <div className="nav-item flex-row" onClick={() => { navigate(PROTECTED_ROUTES.ZK_SEND_USER_RP.FULL_PATH, { replace: true }) }}>
                            <img src={sendUserIcon} alt="Enviar Usuario Icon" className='nav-item-icon' />
                            <span className='nav-item-name'> Carga Administrador </span>
                        </div>
                    )}


                    {userGrants.includes(501) && (
                        <div className="nav-item flex-row" onClick={() => { navigate(PROTECTED_ROUTES.ZK_BULK_ACCESS_UPLOAD_RP.FULL_PATH, { replace: true }) }}>
                            <img src={bulkUploadIcon} alt="Enviar Usuario Icon" className='nav-item-icon' />
                            <span className='nav-item-name'> Carga Masiva Accesos </span>
                        </div>
                    )}
                </div>
            )}


            {hasConfigurationGrants
                && (
                    <div className="navbar-section flex-column">
                        <h2 className="section-tittle"> Configuración </h2>
                        {userGrants.includes(600) && (
                            <div className="nav-item flex-row" onClick={() => { navigate(PROTECTED_ROUTES.CONFIG_USERS.FULL_PATH, { replace: true }) }}>
                                <img src={usersIcon} alt="Inicio Icon" className='nav-item-icon' />
                                <span className='nav-item-name'> Usuarios </span>
                            </div>

                        )}
                        {userGrants.includes(700)
                            && (
                                <div className="nav-item flex-row" onClick={() => { navigate(PROTECTED_ROUTES.CONFIG_PROFILES.FULL_PATH, { replace: true }) }}>
                                    <img src={profilesIcon} alt="Inicio Icon" className='nav-item-icon' />
                                    <span className='nav-item-name'> Perfiles </span>
                                </div>

                            )}
                        {userGrants.includes(800)
                            && (
                                <div className="nav-item flex-row" onClick={() => { navigate(PROTECTED_ROUTES.CONFIGS_LOGS.FULL_PATH, { replace: true }) }}>
                                    <img src={logsIcon} alt="Inicio Icon" className='nav-item-icon' />
                                    <span className='nav-item-name'> Auditoria </span>
                                </div>

                            )}
                        {userGrants.includes(900)
                            && (
                                <div className="nav-item flex-row" onClick={() => { navigate(PROTECTED_ROUTES.CLIENT_CONFIG.FULL_PATH, { replace: true }) }}>
                                    <img src={logsIcon} alt="Inicio Icon" className='nav-item-icon' />
                                    <span className='nav-item-name'> Mantenedor Clientes </span>
                                </div>

                            )}
                    </div>
                )}

            <div className="navbar-section flex-column">
                <h2 className="section-tittle"> Cuenta </h2>
                <div className="nav-item flex-row" onClick={handleLogout}>
                    <img src={logoutIcon} alt="Inicio Icon" className='nav-item-icon' />
                    <span className='nav-item-name'>Cerrar Sesión</span>
                </div>
            </div>
        </div>
    );
}

export default Navbar;