import { useState } from 'react';
import { toast } from 'react-toastify';
import { fetchProfiles, fetchCreateProfile, fetchUpdateProfile, fetchDeleteProfile } from '../../../api/usersApiRequest';
import './profile.css';
import { useNavigate } from 'react-router-dom';
import { PUBLIC_ROUTES } from '../../../routes';
import deleteIcon from '../../../assets/icons/delete-action.png';
import modifyIcon from '../../../assets/icons/edit-action.png';

const Profile = () => {

    const navigate = useNavigate();

    const [profileName, setProfileName] = useState('');
    const [profileNameInput, setProfileNameInput] = useState('');
    const [selectedProfileName, setSelectedProfileName] = useState('');
    const [allProfiles, setAllProfiles] = useState([]);
    const [filteredProfiles, setFilteredProfiles] = useState([]);
    const [loading, setLoading] = useState(false);
    const [showModal, setShowModal] = useState(false);
    const [showEditModal, setShowEditModal] = useState(false);
    const [selectedGrants, setSelectedGrants] = useState([]);
    const [editingProfile, setEditingProfile] = useState(0);
    const [showDeleteConfirmationModal, setShowDeleteConfirmationModal] = useState(false);
    const [profileToDelete, setProfileToDelete] = useState(null);

    const availableGrants = [
        { id: 200, name: 'VER FICHA CLIENTES', section: 'FICHA CLIENTE', seccion: 'FICHA CLIENTE' },
        { id: 300, name: 'VER EQUIPOS CLIENTE', section: 'FICHA CLIENTE', seccion: 'FICHA CLIENTE' },
        { id: 301, name: 'VER CONFIGURACIÓN EQUIPOS', section: 'FICHA CLIENTE', seccion: 'FICHA CLIENTE' },
        { id: 900, name: 'VER MANTENEDOR DE CLIENTES', section: 'FICHA CLIENTE', seccion: 'FICHA CLIENTE' },

        { id: 401, name: 'VISUALIZAR LICENCIA', section: 'LICENCIAS', seccion: 'LICENCIAS' },
        { id: 400, name: 'EXTENDER LICENCIA', section: 'LICENCIAS', seccion: 'LICENCIAS' },

        { id: 500, name: 'CARGA ADMINISTRADOR ZK', section: 'ACCESOS ZK', seccion: 'ACCESOS ZK' },
        { id: 501, name: 'CARGA MASIVA PERFILES', section: 'ACCESOS ZK', seccion: 'ACCESOS ZK' },

        { id: 600, name: 'VER USUARIOS', section: 'USUARIOS', seccion: 'USUARIOS' },
        { id: 601, name: 'CREAR USUARIOS', section: 'USUARIOS', seccion: 'USUARIOS' },
        { id: 602, name: 'EDITAR USUARIOS', section: 'USUARIOS', seccion: 'USUARIOS' },

        { id: 700, name: 'VER PERFILES', section: 'PERFILES', seccion: 'PERFILES' },
        { id: 701, name: 'CREAR PERFILES', section: 'PERFILES', seccion: 'PERFILES' },
        { id: 702, name: 'EDITAR PERFILES', section: 'PERFILES', seccion: 'PERFILES' },
        { id: 703, name: 'ELIMINAR PERFILES', section: 'PERFILES', seccion: 'PERFILES' },

        { id: 800, name: 'VER AUDITORIA', section: 'AUDITORIA', seccion: 'AUDITORIA' }
    ];


    const handleSubmit = () => {
        if (loading) return;

        setLoading(true);

        fetchProfiles()
            .then((response) => {
                if (response) {
                    setAllProfiles(response.data);
                    applyFilter(profileName, response.data);
                }
            })
            .catch((error) => {
                if (error.code === "ERR_NETWORK") {
                    toast.error("No se pudo establecer conexión con el servidor");
                } else if (error.response?.data) {
                    switch (error.response.data.statusCode) {
                        case 400:
                            toast.warning(error.response.data.message || 'Parámetros de búsqueda inválidos');
                            break;
                        case 401:
                            navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
                            toast.warning('Su sesión ha expirado.');
                            break;
                        case 403:
                            toast.warning('No tiene permisos para ver los perfiles');
                            break;
                        case 500:
                            toast.error(error.response.data.message || 'Error interno al cargar perfiles');
                            break;
                        default:
                            toast.error(error.response.data.message || 'Error al cargar perfiles');
                            break;
                    }
                } else {
                    toast.error('Error desconocido al cargar perfiles');
                }
                setAllProfiles([]);
                setFilteredProfiles([]);
            })
            .finally(() => {
                setLoading(false);
            });
    };

    const applyFilter = (filterText, profilesToFilter = allProfiles) => {
        if (!filterText.trim()) {
            setFilteredProfiles(profilesToFilter);
            return;
        }

        const filtered = profilesToFilter.filter(profile =>
            profile.name.toLowerCase().includes(filterText.toLowerCase())
        );
        setFilteredProfiles(filtered);
    };

    const handleNewProfile = () => {
        setShowModal(true);
        setProfileName('');
        setSelectedGrants([]);
    };

    const handleGrantSelection = (grantId) => {
        setSelectedGrants(prev =>
            prev.includes(grantId)
                ? prev.filter(id => id !== grantId)
                : [...prev, grantId]
        );
    };

    const handleCreateProfile = () => {
        if (!profileNameInput.trim()) {
            toast.warning('Ingrese un nombre para el perfil');
            return;
        }
        if (selectedGrants.length === 0) {
            toast.warning('Seleccione al menos un permiso');
            return;
        }

        setLoading(true);
        
        fetchCreateProfile(profileNameInput, selectedGrants)
            .then((response) => {
                if (response) {
                    toast.success('Perfil creado exitosamente');
                    setShowModal(false);
                    handleSubmit();
                }
            })
            .catch((error) => {
                if (error.code === "ERR_NETWORK") {
                    toast.error("Error de conexión. Verifique su red e intente nuevamente");
                } else if (error.response?.data) {
                    switch (error.response.data.statusCode) {
                        case 400:
                            toast.warning(error.response.data.message || 'Datos del perfil inválidos');
                            break;
                        case 401:
                            navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
                            toast.warning('Su sesión ha expirado.');
                            break;
                        case 500:
                            toast.error(error.response.data.message || 'Error interno del servidor');
                            break;
                        default:
                            toast.error(error.response.data.message || 'Error al crear perfil');
                            break;
                    }
                } else {
                    toast.error('Error desconocido al crear perfil');
                }
            })
            .finally(() => {
                setProfileName('');
                setSelectedGrants([]);
                setLoading(false);
            });
    };

    const handleEditProfile = (profile) => {
        if (!profile || !profile.name) {
            toast.error("El perfil seleccionado no es válido");
            return;
        }

        setEditingProfile(profile);
        setSelectedProfileName(profile.name);
        setSelectedGrants(profile.grants || []);
        setShowEditModal(true);
    };

    const handleUpdateProfile = () => {
        if (!selectedProfileName.trim()) {
            toast.warning('Ingrese un nombre para el perfil');
            return;
        }

        if (selectedGrants.length === 0) {
            toast.warning('Seleccione al menos un permiso');
            return;
        }

        setLoading(true);

        fetchUpdateProfile(
            editingProfile.profileId,
            selectedProfileName,
            selectedGrants
        )
            .then((response) => {
                if (response) {
                    toast.success('Perfil actualizado exitosamente');
                    setShowEditModal(false);
                    handleSubmit();
                }
            })
            .catch((error) => {
                if (error.code === "ERR_NETWORK") {
                    toast.error("No se pudo establecer conexión con el servidor");
                } else if (error.response?.data) {
                    switch (error.response.data.statusCode) {
                        case 400:
                            toast.warning(error.response.data.message || 'Datos de perfil inválidos.');
                            break;
                        case 401:
                            navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
                            toast.warning('Su sesión ha expirado.');
                            break;
                        case 500:
                            toast.error(error.response.data.message || 'Error interno del servidor.');
                            break;
                        default:
                            toast.error(error.response.data.message || 'Error al actualizar perfil.');
                            break;
                    }
                } else {
                    toast.error('Error desconocido al actualizar perfil.');
                }
            })
            .finally(() => {
                setLoading(false);
            });
    };

    const handleDeleteProfile = (profile) => {
        setProfileToDelete(profile);  // Guarda el perfil que se desea eliminar
        setShowDeleteConfirmationModal(true);  // Muestra el modal de confirmación
    };

    return (
        <div className='zk-profile-container'>
            <div className='zk-filter-section'>
                <h2 className='zk-filter-title'>Administración de Perfiles</h2>
                <form onSubmit={(e) => {
                    e.preventDefault();
                    handleSubmit();
                }}>
                    <div className='zk-filter-row'>
                        <div className='zk-filter-group'>
                            <label>Nombre del perfil:</label>
                            <input
                                type='text'
                                value={profileName}
                                onChange={(e) => setProfileName(e.target.value)}
                                placeholder='Ej: Administrador'
                                disabled={loading}
                            />
                        </div>
                    </div>
                    <div className='zk-filter-actions'>
                        <button type='submit' className='zk-btn-primary' disabled={loading}>
                            {loading ? 'Buscando...' : 'Buscar'}
                        </button>
                        <button
                            type='button'
                            className='zk-btn-secondary'
                            onClick={handleNewProfile}
                            disabled={loading}>
                            Nuevo Perfil
                        </button>
                    </div>
                </form>
            </div>

            <div className='zk-results-section'>
                {loading ? (
                    <div className='zk-loading'>Cargando perfiles...</div>
                ) : (
                    <div className='zk-table-container'>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nombre</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filteredProfiles.length > 0 ? (
                                    filteredProfiles.map(profile => (
                                        <tr key={profile.profileId}>
                                            <td>{profile.profileId}</td>
                                            <td>{profile.name}</td>
                                            <td className='zk-actions actions-container'>
                                                <img className='action-icon' src={modifyIcon} alt="" onClick={() => handleEditProfile(profile)} />
                                                <img className='action-icon' src={deleteIcon} alt="" onClick={() => handleDeleteProfile(profile)} />
                                            </td>
                                        </tr>
                                    ))
                                ) : (
                                    <tr>
                                        <td colSpan="3" className='zk-no-results'>
                                            {allProfiles.length === 0
                                                ? 'No se encontraron perfiles'
                                                : 'No hay resultados que coincidan con la búsqueda'}
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                )}
            </div>

            {/* Modal de confirmación de eliminación */}
            {showDeleteConfirmationModal && (
                <div className='zk-modal-overlay'>
                    <div className='zk-modal-content'>
                        <h2 className='profile-form-tittle'>Confirmar Eliminación</h2>
                        <p>¿Estás seguro de que deseas eliminar el perfil <strong>{profileToDelete?.name}</strong>?</p>

                        <div className='zk-modal-actions'>
                            <button
                                className='zk-btn-primary'
                                onClick={() => {
                                    setShowDeleteConfirmationModal(false);
                                    if (profileToDelete) {
                                        setLoading(true);
                                        fetchDeleteProfile(profileToDelete.profileId)
                                            .then((response) => {
                                                if (response) {
                                                    toast.success('Perfil eliminado exitosamente');
                                                    handleSubmit();
                                                }
                                            })
                                            .catch((error) => {
                                                if (error.code === "ERR_NETWORK") {
                                                    toast.error("No se pudo establecer conexión con el servidor");
                                                } else if (error.response?.data) {
                                                    switch (error.response.data.statusCode) {
                                                        case 400:
                                                            toast.warning(error.response.data.message);
                                                            break;
                                                        case 401:
                                                            navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
                                                            toast.warning('Su sesión ha expirado.');
                                                            break;
                                                        case 500:
                                                            toast.error(error.response.data.message || 'Error interno del servidor');
                                                            break;
                                                        default:
                                                            toast.error(error.response.data.message || 'Error al eliminar perfil');
                                                            break;
                                                    }
                                                } else {
                                                    toast.error('Error desconocido al eliminar perfil');
                                                }
                                            })
                                            .finally(() => {
                                                setLoading(false);
                                                setProfileToDelete(null);
                                            });
                                    }
                                }}
                                disabled={loading}
                            >
                                {loading ? 'Eliminando...' : 'Confirmar'}
                            </button>
                            <button
                                className='zk-btn-secondary'
                                onClick={() => setShowDeleteConfirmationModal(false)}
                                disabled={loading}
                            >
                                Cancelar
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* Modal para crear perfil */}
            {showModal && (
                <div className='zk-modal-overlay'>
                    <div className='zk-modal-content'>
                        <h2 className='profile-form-tittle'>Crear Nuevo Perfil</h2>
                        <div className='zk-filter-group'>
                            <label>Nombre del Perfil:</label>
                            <input
                                type='text'
                                value={profileNameInput}
                                onChange={(e) => setProfileNameInput(e.target.value)}
                                placeholder='Ej: Administrador'
                            />
                        </div>


                        <div className='zk-grants-section'>
                            <h3>Funcionalidades:</h3>
                            {Object.entries(
                                availableGrants.reduce((acc, grant) => {
                                    acc[grant.seccion] = acc[grant.seccion] || [];
                                    acc[grant.seccion].push(grant);
                                    return acc;
                                }, {})
                            ).map(([seccion, grants]) => (
                                <div key={seccion} className='zk-grant-group'>
                                    <h4>{seccion}</h4>
                                    <div className='zk-grants-grid'>
                                        {grants.map(grant => (
                                            <div
                                                key={grant.id}
                                                className={`zk-grant-card ${selectedGrants.includes(grant.id) ? 'selected' : ''}`}
                                                onClick={() => handleGrantSelection(grant.id)}
                                            >
                                                <input
                                                    type='checkbox'
                                                    checked={selectedGrants.includes(grant.id)}
                                                    disabled={loading}
                                                    readOnly
                                                />
                                                <span>{grant.name}</span>
                                            </div>
                                        ))}
                                    </div>
                                </div>
                            ))}
                        </div>



                        <div className='zk-modal-actions'>
                            <button
                                className='zk-btn-primary'
                                onClick={handleCreateProfile}
                                disabled={loading}
                            >
                                {loading ? 'Creando perfil...' : 'Crear Perfil'}
                            </button>
                            <button
                                className='zk-btn-secondary'
                                onClick={() => setShowModal(false)}
                                disabled={loading}
                            >
                                Cancelar
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* Modal para editar perfil */}
            {showEditModal && (
                <div className='zk-modal-overlay'>
                    <div className='zk-modal-content'>
                        <h2 className='profile-form-tittle'>Editar Perfil</h2>
                        <div className='zk-filter-group'>
                            <label>Nombre del Perfil:</label>
                            <input
                                type='text'
                                value={selectedProfileName}
                                onChange={(e) => setSelectedProfileName(e.target.value)}
                                placeholder='Ej: Administrador'
                                disabled
                            />
                        </div>

                        <div className='zk-grants-section'>
                            <h3>Funcionalidades:</h3>
                            {Object.entries(
                                availableGrants.reduce((acc, grant) => {
                                    acc[grant.seccion] = acc[grant.seccion] || [];
                                    acc[grant.seccion].push(grant);
                                    return acc;
                                }, {})
                            ).map(([seccion, grants]) => (
                                <div key={seccion} className='zk-grant-group'>
                                    <h4>{seccion}</h4>
                                    <div className='zk-grants-grid'>
                                        {grants.map(grant => (
                                            <div
                                                key={grant.id}
                                                className={`zk-grant-card ${selectedGrants.includes(grant.id) ? 'selected' : ''}`}
                                                onClick={() => handleGrantSelection(grant.id)}
                                            >
                                                <input
                                                    type='checkbox'
                                                    checked={selectedGrants.includes(grant.id)}
                                                    disabled={loading}
                                                    readOnly
                                                />
                                                <span>{grant.name}</span>
                                            </div>
                                        ))}
                                    </div>
                                </div>
                            ))}
                        </div>

                        <div className='zk-modal-actions'>
                            <button
                                className='zk-btn-primary'
                                onClick={handleUpdateProfile}
                                disabled={loading}
                            >
                                {loading ? 'Actualizando perfil...' : 'Actualizar Perfil'}
                            </button>
                            <button
                                className='zk-btn-secondary'
                                onClick={() => setShowEditModal(false)}
                                disabled={loading}
                            >
                                Cancelar
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default Profile;
