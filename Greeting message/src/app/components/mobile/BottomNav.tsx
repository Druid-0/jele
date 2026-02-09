import { Home, Calendar, Award, User } from 'lucide-react';

interface BottomNavProps {
  activeTab: 'home' | 'schedule' | 'grades' | 'profile';
  onTabChange: (tab: 'home' | 'schedule' | 'grades' | 'profile') => void;
}

export function BottomNav({ activeTab, onTabChange }: BottomNavProps) {
  const tabs = [
    { id: 'home' as const, label: 'Главная', icon: Home },
    { id: 'schedule' as const, label: 'Расписание', icon: Calendar },
    { id: 'grades' as const, label: 'Оценки', icon: Award },
    { id: 'profile' as const, label: 'Профиль', icon: User },
  ];

  return (
    <div className="bg-white border-t border-gray-200 px-2 py-2 safe-bottom">
      <div className="flex items-center justify-around">
        {tabs.map((tab) => {
          const Icon = tab.icon;
          const isActive = activeTab === tab.id;
          
          return (
            <button
              key={tab.id}
              onClick={() => onTabChange(tab.id)}
              className={`flex flex-col items-center justify-center px-4 py-2 rounded-lg min-w-[70px] transition-all ${
                isActive
                  ? 'text-blue-600'
                  : 'text-gray-600'
              }`}
            >
              <Icon className={`w-6 h-6 mb-1 ${isActive ? 'text-blue-600' : 'text-gray-600'}`} />
              <span className={`text-xs font-medium ${isActive ? 'text-blue-600' : 'text-gray-600'}`}>
                {tab.label}
              </span>
            </button>
          );
        })}
      </div>
    </div>
  );
}
