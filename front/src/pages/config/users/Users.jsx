import { useState } from 'react';
import { toast } from 'react-toastify';
import { useNavigate } from 'react-router-dom';
import { fetchUsers, fetchCreateUser, fetchUpdateUser, fetchProfiles } from '../../../api/usersApiRequest';
import { PUBLIC_ROUTES } from '../../../routes';
import modifyIcon from '../../../assets/icons/edit-action.png';
import './users.css';

const Users = () => {
    const [nameFilter, setNameFilter] = useState('');
    const [emailFilter, setEmailFilter] = useState('');
    const [isActiveFilter, setIsActiveFilter] = useState(null);
    const [users, setUsers] = useState([]);
    const [profiles, setProfiles] = useState([]);
    const [loading, setLoading] = useState(false);
    const [showModal, setShowModal] = useState(false);
    const [showEditModal, setShowEditModal] = useState(false);
    const [editingUser, setEditingUser] = useState(null);
    const navigate = useNavigate();

    // Estado separado para formulario de creación
    const [createFormData, setCreateFormData] = useState({
        name: '',
        email: '',
        profileId: '',
        profileName: '',
        password: '',
        confirmPassword: '',
        isActive: true
    });

    // Estado separado para formulario de edición
    const [editFormData, setEditFormData] = useState({
        name: '',
        email: '',
        profileId: '',
        profileName: '',
        password: '',
        confirmPassword: '',
        isActive: true
    });

    const handleSubmit = (e) => {
        e.preventDefault();
        if (loading) return;

        setLoading(true);

        fetchUsers(nameFilter, emailFilter, isActiveFilter)
            .then((response) => {
                if (response) {
                    setUsers(response.data);
                }
            })
            .catch((error) => {
                if (error.code === "ERR_NETWORK") {
                    toast.error("No se pudo establecer conexión con el servidor");
                } else if (error.response?.data) {
                    const { statusCode, message } = error.response.data;

                    switch (statusCode) {
                        case 400:
                            toast.warning(message || 'Parámetros de búsqueda inválidos');
                            break;
                        case 401:
                            navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
                            toast.warning('Su sesión ha expirado.');
                            break;
                        case 403:
                            toast.warning(message || 'No tiene permisos para ver usuarios');
                            break;
                        case 404:
                            toast.warning(message || 'No se encontraron usuarios');
                            break;
                        case 500:
                            toast.error(message || 'Error interno del servidor');
                            break;
                        default:
                            toast.error(message || 'Error al cargar usuarios');
                            break;
                    }
                } else {
                    toast.error('Error desconocido al cargar usuarios');
                }
                setUsers([]);
            })
            .finally(() => {
                setLoading(false);
            });
    };

    const handleNewUser = () => {
        setCreateFormData({
            name: '',
            email: '',
            profileId: '',
            profileName: '',
            password: '',
            confirmPassword: '',
            isActive: true
        });

        fetchProfiles()
            .then((response) => {
                if (response) {
                    toast.success(response.message);
                    setProfiles(response.data);
                }
            })
            .catch((error) => {
                if (error.code === "ERR_NETWORK") {
                    toast.error("No se pudo establecer conexión con la API de usuarios.");
                } else if (error.response.data) {
                    switch (error.response.data.statusCode) {
                        case 400:
                            setProfiles([]);
                            toast.warning(error.response.data.message);
                            break;
                        case 401:
                            navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
                            toast.warning('Su sesión ha expirado.');
                            break;
                        case 500:
                            setProfiles([]);
                            toast.error(error.response.data.message);
                            break;
                        default:
                            break;
                    }
                } else {
                    toast.error("Error desconocido.");
                }
            })
            .finally(() => {
                setLoading(false);
            });

        setShowModal(true);
    };

    const handleEditUser = (user) => {
        setEditingUser(user);

        setEditFormData({
            name: user.name,
            email: user.email,
            profileId: user.profileId,
            profileName: user.profileName,
            password: '',
            confirmPassword: '',
            isActive: user.isActive
        });

        fetchProfiles()
            .then((response) => {
                if (response) {
                    setProfiles(response.data);
                }
            })
            .catch((error) => {
                if (error.code === "ERR_NETWORK") {
                    toast.error("No se pudo establecer conexión con la API de usuarios.");
                } else if (error.response.data) {
                    switch (error.response.data.statusCode) {
                        case 400:
                            setProfiles([]);
                            toast.warning(error.response.data.message);
                            break;
                        case 401:
                            navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
                            toast.warning('Su sesión ha expirado.');
                            break;
                        case 500:
                            setProfiles([]);
                            toast.error(error.response.data.message);
                            break;
                        default:
                            break;
                    }
                } else {
                    toast.error("Error desconocido.");
                }
            })
            .finally(() => {
                setLoading(false);
            });

        setShowEditModal(true);
    };

    const handleCreateInputChange = (e) => {
        const { name, value, type, checked } = e.target;
        setCreateFormData(prev => ({
            ...prev,
            [name]: type === 'checkbox' ? checked : value
        }));
    };

    const handleEditInputChange = (e) => {
        const { name, value, type, checked } = e.target;
        setEditFormData(prev => ({
            ...prev,
            [name]: type === 'checkbox' ? checked : value
        }));
    };

    const handleCreateProfileChange = (e) => {
        const selectedProfile = profiles.find(p => p.profileId === Number(e.target.value));
        setCreateFormData(prev => ({
            ...prev,
            profileId: e.target.value,
            profileName: selectedProfile?.name || ''
        }));
    };

    const handleEditProfileChange = (e) => {
        const selectedProfile = profiles.find(p => p.profileId === Number(e.target.value));
        setEditFormData(prev => ({
            ...prev,
            profileId: e.target.value,
            profileName: selectedProfile?.name || ''
        }));
    };

    const validateCreateForm = () => {
        if (!createFormData.name.trim()) {
            toast.warning('El nombre es requerido');
            return false;
        }
        if (!createFormData.email.trim()) {
            toast.warning('El email es requerido');
            return false;
        }
        if (!createFormData.profileId) {
            toast.warning('Seleccione un perfil');
            return false;
        }
        if (!createFormData.password) {
            toast.warning('La contraseña es requerida');
            return false;
        }
        return true;
    };

    const validateEditForm = () => {
        if (!editFormData.name.trim()) {
            toast.warning('El nombre es requerido');
            return false;
        }
        if (!editFormData.email.trim()) {
            toast.warning('El email es requerido');
            return false;
        }
        if (!editFormData.profileId) {
            toast.warning('Seleccione un perfil');
            return false;
        }
        return true;
    };

    const handleCreateUser = () => {
        if (!validateCreateForm()) return;

        setLoading(true);

        fetchCreateUser({
            name: createFormData.name,
            email: createFormData.email,
            password: createFormData.password,
            profileId: createFormData.profileId
        })
            .then((response) => {
                if (response) {
                    toast.success('Usuario creado exitosamente');
                    setShowModal(false);
                    // Recargar lista de usuarios
                    handleSubmit({ preventDefault: () => { } });
                }
            })
            .catch((error) => {
                if (error.code === "ERR_NETWORK") {
                    toast.error("Error de conexión. Verifique su red e intente nuevamente");
                } else if (error.response?.data) {
                    const { statusCode, message } = error.response.data;

                    switch (statusCode) {
                        case 400:
                            toast.warning(message || 'Datos del usuario inválidos o incompletos');
                            break;
                        case 401:
                            navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
                            toast.warning('Su sesión ha expirado.');
                            break;
                        case 403:
                            toast.warning(message || 'No tiene permisos para crear usuarios');
                            break;
                        case 409:
                            toast.warning(message || 'El correo electrónico ya está registrado');
                            break;
                        case 500:
                            toast.error(message || 'Error interno al crear usuario');
                            break;
                        default:
                            toast.error(message || 'Error al crear usuario');
                            break;
                    }
                } else {
                    toast.error('Error desconocido al crear usuario');
                }
            })
            .finally(() => {
                setLoading(false);
            });
    };

    const handleUpdateUser = () => {
        if (!validateEditForm()) return;

        setLoading(true);

        fetchUpdateUser({
            id: editingUser.id,
            name: editFormData.name,
            email: editFormData.email,
            password: editFormData.password || undefined,
            isActive: editFormData.isActive,
            profileId: editFormData.profileId
        })
            .then((response) => {
                if (response) {
                    toast.success('Usuario actualizado exitosamente');
                    setShowEditModal(false);
                    // Recargar lista de usuarios
                    handleSubmit({ preventDefault: () => { } });
                }
            })
            .catch((error) => {
                if (error.code === "ERR_NETWORK") {
                    toast.error("Error de conexión. Verifique su red e intente nuevamente");
                } else if (error.response?.data) {
                    const { statusCode, message } = error.response.data;

                    switch (statusCode) {
                        case 400:
                            toast.warning(message || 'Datos del usuario inválidos');
                            break;
                        case 401:
                            navigate(PUBLIC_ROUTES.LOGIN.FULL_PATH, { replace: true });
                            toast.warning('Su sesión ha expirado.');
                            break;
                        case 404:
                            toast.warning(message || 'Usuario no encontrado');
                            break;
                        case 409:
                            toast.warning(message || 'El correo ya está registrado');
                            break;
                        case 500:
                            toast.error(message || 'Error interno al actualizar usuario');
                            break;
                        default:
                            toast.error(message || 'Error al actualizar usuario');
                            break;
                    }
                } else {
                    toast.error('Error desconocido al actualizar usuario');
                }
            })
            .finally(() => {
                setLoading(false);
            });
    };

    return (
        <div className='zk-users-container'>
            <div className='zk-filter-section'>
                <h2 className='zk-filter-title'>Administración de Usuarios</h2>
                <form onSubmit={handleSubmit}>
                    <div className='zk-filter-row'>
                        <div className='zk-filter-group'>
                            <label>Nombre:</label>
                            <input
                                type='text'
                                value={nameFilter}
                                onChange={(e) => setNameFilter(e.target.value)}
                                placeholder='Filtrar por nombre'
                                disabled={loading}
                            />
                        </div>
                        <div className='zk-filter-group'>
                            <label>Email:</label>
                            <input
                                type='text'
                                value={emailFilter}
                                onChange={(e) => setEmailFilter(e.target.value)}
                                placeholder='Filtrar por email'
                                disabled={loading}
                            />
                        </div>
                        <div className='zk-filter-group'>
                            <label>Estado:</label>
                            <select
                                value={isActiveFilter ?? ''}
                                onChange={(e) => setIsActiveFilter(e.target.value ? JSON.parse(e.target.value) : null)}
                                disabled={loading}
                            >
                                <option value=''>Todos</option>
                                <option value={true}>Activos</option>
                                <option value={false}>Inactivos</option>
                            </select>
                        </div>
                    </div>
                    <div className='zk-filter-actions'>
                        <button type='submit' className='zk-btn-primary' disabled={loading}>
                            {loading ? 'Buscando...' : 'Buscar'}
                        </button>
                        <button
                            type='button'
                            className='zk-btn-secondary'
                            onClick={handleNewUser}
                            disabled={loading}>
                            Nuevo Usuario
                        </button>
                    </div>
                </form>
            </div>

            <div className='zk-results-section'>
                {loading ? (
                    <div className='zk-loading'>Cargando usuarios...</div>
                ) : (
                    <div className='zk-table-container'>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nombre</th>
                                    <th>Email</th>
                                    <th>Perfil</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                {users.length > 0 ? users.map(user => (
                                    <tr key={user.id}>
                                        <td>{user.id}</td>
                                        <td>{user.name}</td>
                                        <td>{user.email}</td>
                                        <td>{user.profileName}</td>
                                        <td>
                                            <span className={`zk-status-badge ${user.isActive ? 'active' : 'inactive'}`}>
                                                {user.isActive ? 'Activo' : 'Inactivo'}
                                            </span>
                                        </td>
                                        <td className='zk-actions actions-container'>
                                            <img className='action-icon' src={modifyIcon} alt="" onClick={() => handleEditUser(user)} />
                                        </td>
                                    </tr>
                                )) : (
                                    <tr>
                                        <td colSpan="6" className='zk-no-results'>
                                            No se encontraron usuarios
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                )}
            </div>

            {showModal && (
                <div className='zk-modal-overlay'>
                    <div className='zk-modal-content'>
                        <h2>Crear Nuevo Usuario</h2>
                        <div className='zk-filter-row'>
                            <div className='zk-filter-group'>
                                <label>Nombre:</label>
                                <input
                                    type='text'
                                    name='name'
                                    value={createFormData.name}
                                    onChange={handleCreateInputChange}
                                    placeholder='Ej: Juan Pérez'
                                    disabled={loading}
                                    required
                                />
                            </div>
                            <div className='zk-filter-group'>
                                <label>Email:</label>
                                <input
                                    type='email'
                                    name='email'
                                    value={createFormData.email}
                                    onChange={handleCreateInputChange}
                                    placeholder='Ej: usuario@empresa.com'
                                    disabled={loading}
                                    required
                                />
                            </div>
                        </div>
                        <div className='zk-filter-row'>
                            <div className='zk-filter-group'>
                                <label>Perfil:</label>
                                <select
                                    name='profileId'
                                    value={createFormData.profileId}
                                    onChange={handleCreateProfileChange}
                                    disabled={loading}
                                    required
                                >
                                    <option value=''>Seleccione un perfil</option>
                                    {profiles.map(profile => (
                                        <option key={profile.profileId} value={profile.profileId}>
                                            {profile.name}
                                        </option>
                                    ))}
                                </select>
                            </div>
                        </div>
                        <div className='zk-filter-row'>
                            <div className='zk-filter-group'>
                                <label>Contraseña:</label>
                                <input
                                    type='password'
                                    name='password'
                                    value={createFormData.password}
                                    onChange={handleCreateInputChange}
                                    placeholder='Ingrese contraseña'
                                    disabled={loading}
                                    required
                                />
                            </div>
                        </div>
                        <div className='zk-modal-actions'>
                            <button
                                className='zk-btn-primary'
                                onClick={handleCreateUser}
                                disabled={loading}>
                                {loading ? 'Creando...' : 'Crear Usuario'}
                            </button>
                            <button
                                className='zk-btn-secondary'
                                onClick={() => setShowModal(false)}
                                disabled={loading}>
                                Cancelar
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {showEditModal && (
                <div className='zk-modal-overlay'>
                    <div className='zk-modal-content'>
                        <h2>Editar Usuario</h2>
                        <div className='zk-filter-row'>
                            <div className='zk-filter-group'>
                                <label>Nombre:</label>
                                <input
                                    type='text'
                                    name='name'
                                    value={editFormData.name}
                                    onChange={handleEditInputChange}
                                    disabled={loading}
                                    required
                                />
                            </div>
                            <div className='zk-filter-group'>
                                <label>Email:</label>
                                <input
                                    type='email'
                                    name='email'
                                    value={editFormData.email}
                                    onChange={handleEditInputChange}
                                    disabled={loading}
                                    required
                                />
                            </div>
                        </div>
                        <div className='zk-filter-row'>
                            <div className='zk-filter-group'>
                                <label>Perfil:</label>
                                <select
                                    name='profileId'
                                    value={editFormData.profileId}
                                    onChange={handleEditProfileChange}
                                    disabled={loading}
                                    required
                                >
                                    <option value=''>Seleccione un perfil</option>
                                    {profiles.map(profile => (
                                        <option key={profile.profileId} value={profile.profileId}>
                                            {profile.name}
                                        </option>
                                    ))}
                                </select>
                            </div>
                            <div className='zk-filter-group'>
                                <label>Estado:</label>
                                <label className='zk-switch'>
                                    <input
                                        type='checkbox'
                                        name='isActive'
                                        checked={editFormData.isActive}
                                        onChange={handleEditInputChange}
                                        disabled={loading}
                                    />
                                    <span className='zk-slider'></span>
                                    <span className='zk-switch-label'>
                                        {editFormData.isActive ? 'Activo' : 'Inactivo'}
                                    </span>
                                </label>
                            </div>
                        </div>
                        <div className='zk-filter-row'>
                            <div className='zk-filter-group'>
                                <label>Nueva Contraseña:</label>
                                <input
                                    type='password'
                                    name='password'
                                    value={editFormData.password}
                                    onChange={handleEditInputChange}
                                    placeholder='Dejar en blanco para no cambiar'
                                    disabled={loading}
                                />
                            </div>
                        </div>
                        <div className='zk-modal-actions'>
                            <button
                                className='zk-btn-primary'
                                onClick={handleUpdateUser}
                                disabled={loading}>
                                {loading ? 'Actualizando...' : 'Actualizar Usuario'}
                            </button>
                            <button
                                className='zk-btn-secondary'
                                onClick={() => setShowEditModal(false)}
                                disabled={loading}>
                                Cancelar
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default Users;