import { useState } from 'react';
import { MobileFrame } from './components/mobile/MobileFrame';
import { LoginScreen } from './components/mobile/LoginScreen';
import { RoleSelectScreen } from './components/mobile/RoleSelectScreen';
import { ParentMobileApp } from './components/mobile/ParentMobileApp';
import { TeacherMobileApp } from './components/mobile/TeacherMobileApp';
import { StudentMobileApp } from './components/mobile/StudentMobileApp';

type UserRole = 'parent' | 'teacher' | 'student' | null;
type AppScreen = 'login' | 'roleSelect' | 'app';

export default function App() {
  const [screen, setScreen] = useState<AppScreen>('login');
  const [userRole, setUserRole] = useState<UserRole>(null);

  const handleLogin = () => {
    setScreen('roleSelect');
  };

  const handleSelectRole = (role: 'parent' | 'teacher' | 'student') => {
    setUserRole(role);
    setScreen('app');
  };

  const handleLogout = () => {
    setUserRole(null);
    setScreen('login');
  };

  const handleBack = () => {
    setScreen('login');
  };

  return (
    <MobileFrame>
      {screen === 'login' && <LoginScreen onLogin={handleLogin} />}
      
      {screen === 'roleSelect' && (
        <RoleSelectScreen onSelectRole={handleSelectRole} onBack={handleBack} />
      )}

      {screen === 'app' && userRole === 'parent' && (
        <ParentMobileApp onLogout={handleLogout} />
      )}

      {screen === 'app' && userRole === 'teacher' && (
        <TeacherMobileApp onLogout={handleLogout} />
      )}

      {screen === 'app' && userRole === 'student' && (
        <StudentMobileApp onLogout={handleLogout} />
      )}
    </MobileFrame>
  );
}