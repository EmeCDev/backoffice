import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import { PROTECTED_ROUTES, PUBLIC_ROUTES } from "../routes";
import { AuthGuard, GrantGuard } from "../guards";
import { Audit, BulkProfileSend, BulkProfileSendAd, BulkProfileSendRp, ClientConfig, ClientData, Home, Login, Panel, Profile, Users, ZkSendUser, ZkSendUserAd, ZkSendUserRp } from ".";
import { ToastContainer } from "react-toastify";

const App = () => {
    return (
        <>
            <BrowserRouter basename="/portal-backoffice">
                <Routes>
                    <Route path={PUBLIC_ROUTES.BASE.FULL_PATH} element={<Navigate replace to={PUBLIC_ROUTES.LOGIN.FULL_PATH} />} />
                    <Route path={PUBLIC_ROUTES.LOGIN.FULL_PATH} element={<Login />} />

                    <Route element={<AuthGuard />}>
                        <Route element={<Panel />}>
                            <Route path={PROTECTED_ROUTES.HOME.FULL_PATH} element={<Home />} />

                            <Route element={<GrantGuard requiredGrant={200} />}>
                                <Route path={PROTECTED_ROUTES.CLIENT_DATA.FULL_PATH} element={<ClientData />} />
                            </Route>
        
                            <Route element={<GrantGuard requiredGrant={500} />}>
                                <Route path={PROTECTED_ROUTES.ZK_SEND_USER.FULL_PATH} element={<ZkSendUser />} />
                            </Route>

                            <Route element={<GrantGuard requiredGrant={501} />}>
                                <Route path={PROTECTED_ROUTES.ZK_BULK_ACCESS_UPLOAD.FULL_PATH} element={<BulkProfileSend />} />
                            </Route>

                            <Route element={<GrantGuard requiredGrant={500} />}>
                                <Route path={PROTECTED_ROUTES.ZK_SEND_USER_AD.FULL_PATH} element={<ZkSendUserAd />} />
                            </Route>

                            <Route element={<GrantGuard requiredGrant={501} />}>
                                <Route path={PROTECTED_ROUTES.ZK_BULK_ACCESS_UPLOAD_AD.FULL_PATH} element={<BulkProfileSendAd />} />
                            </Route>

                            <Route element={<GrantGuard requiredGrant={500} />}>
                                <Route path={PROTECTED_ROUTES.ZK_SEND_USER_RP.FULL_PATH} element={<ZkSendUserRp />} />
                            </Route>

                            <Route element={<GrantGuard requiredGrant={501} />}>
                                <Route path={PROTECTED_ROUTES.ZK_BULK_ACCESS_UPLOAD_RP.FULL_PATH} element={<BulkProfileSendRp />} />
                            </Route>

                            <Route element={<GrantGuard requiredGrant={700} />}>
                                <Route path={PROTECTED_ROUTES.CONFIG_PROFILES.FULL_PATH} element={<Profile />} />
                            </Route>

                            <Route element={<GrantGuard requiredGrant={600} />}>
                                <Route path={PROTECTED_ROUTES.CONFIG_USERS.FULL_PATH} element={<Users />} />
                            </Route>

                            <Route element={<GrantGuard requiredGrant={800} />}>
                                <Route path={PROTECTED_ROUTES.CONFIGS_LOGS.FULL_PATH} element={<Audit />} />
                            </Route>

                            <Route element={<GrantGuard requiredGrant={900} />}>
                                <Route path={PROTECTED_ROUTES.CLIENT_CONFIG.FULL_PATH} element={<ClientConfig />} />
                            </Route>
                        </Route>
                    </Route>

                    <Route path="*" element={
                        <Navigate
                            replace
                            to={PUBLIC_ROUTES.LOGIN.FULL_PATH}
                        />}
                    />
                </Routes>
                <ToastContainer
                    autoClose={6000}
                    closeOnClick
                    pauseOnFocusLoss={false}
                    pauseOnHover={false}
                    position="top-right"
                />
            </BrowserRouter>
        </>
    );
}

export default App;