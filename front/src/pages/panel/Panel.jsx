import Navbar from '../navbar/Navbar';
import { Outlet, useLocation } from 'react-router-dom'; // Importa useLocation
import './styles/panel.css';
import { useState, useEffect } from 'react';
import { PROTECTED_ROUTES } from '../../routes';
import userIcon from '../../assets/icons/logged-user.png';

const Panel = () => {
    
    const [tittle, setTittle] = useState('');
    const [loggedUser, setLoggedUser] = useState('');
    const [loggedUserEmail, setLoggedUserEmail] = useState('');
    const location = useLocation();
    
    let parsedData = {};
    try {
        parsedData = JSON.parse(sessionStorage.getItem("userData")) || {};
    } catch (error) {
        console.error("Error parsing userData:", error);
    }

    useEffect(() => {
        setLoggedUser(parsedData?.name ?? '');
        setLoggedUserEmail(parsedData?.email ?? '');

        const { pathname } = location;
        const pageTitle = Object.values(PROTECTED_ROUTES).find(route => route.FULL_PATH === pathname)?.NAME || 'Página No Encontrada';
        setTittle(pageTitle);
    }, [location]);

    return (
        <>
            <div className="panel-container flex-row full-size">
                <Navbar />
                <div className="panel-content flex-column full-size">
                    <div className="panel-tittle">
                        <h1 className='full-size'>{tittle}</h1>
                        <div className="logged-user-container">
                            <img className='logged-user-icon' src={userIcon} alt="userIcon" />
                            <div className="user-info">
                                <span>{loggedUser ?? 'Usuario'}</span>
                                <span>{loggedUserEmail?? 'Email'} </span>
                            </div>
                        </div>
                    </div>
                    <Outlet />
                </div>
            </div>
        </>
    );
}

export default Panel;
