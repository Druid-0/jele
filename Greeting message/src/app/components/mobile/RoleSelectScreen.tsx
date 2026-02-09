import { Users, BookOpen, UserCircle, ArrowLeft } from 'lucide-react';

interface RoleSelectScreenProps {
  onSelectRole: (role: 'parent' | 'teacher' | 'student') => void;
  onBack: () => void;
}

export function RoleSelectScreen({ onSelectRole, onBack }: RoleSelectScreenProps) {
  return (
    <div className="h-full bg-gray-50 flex flex-col">
      {/* Header */}
      <div className="bg-blue-600 px-6 pt-8 pb-6">
        <button
          onClick={onBack}
          className="text-white mb-4 flex items-center gap-2"
        >
          <ArrowLeft className="w-5 h-5" />
          <span>Назад</span>
        </button>
        <h1 className="text-2xl font-bold text-white">Выберите роль</h1>
        <p className="text-blue-100 mt-1">Как вы будете использовать приложение?</p>
      </div>

      {/* Role Cards */}
      <div className="flex-1 overflow-y-auto px-6 py-6 space-y-4">
        {/* Parent */}
        <button
          onClick={() => onSelectRole('parent')}
          className="w-full bg-white rounded-2xl p-6 shadow-md hover:shadow-lg transition-all border-2 border-transparent hover:border-blue-500 text-left"
        >
          <div className="flex items-start gap-4">
            <div className="w-14 h-14 rounded-full bg-purple-100 flex items-center justify-center flex-shrink-0">
              <Users className="w-7 h-7 text-purple-600" />
            </div>
            <div className="flex-1">
              <h3 className="text-lg font-semibold text-gray-900 mb-1">
                Родитель
              </h3>
              <p className="text-sm text-gray-600">
                Отслеживайте успеваемость детей, просматривайте расписание и общайтесь с преподавателями
              </p>
            </div>
          </div>
        </button>

        {/* Teacher */}
        <button
          onClick={() => onSelectRole('teacher')}
          className="w-full bg-white rounded-2xl p-6 shadow-md hover:shadow-lg transition-all border-2 border-transparent hover:border-green-500 text-left"
        >
          <div className="flex items-start gap-4">
            <div className="w-14 h-14 rounded-full bg-green-100 flex items-center justify-center flex-shrink-0">
              <BookOpen className="w-7 h-7 text-green-600" />
            </div>
            <div className="flex-1">
              <h3 className="text-lg font-semibold text-gray-900 mb-1">
                Преподаватель
              </h3>
              <p className="text-sm text-gray-600">
                Управляйте расписанием, ведите электронный журнал и выставляйте оценки ученикам
              </p>
            </div>
          </div>
        </button>

        {/* Student */}
        <button
          onClick={() => onSelectRole('student')}
          className="w-full bg-white rounded-2xl p-6 shadow-md hover:shadow-lg transition-all border-2 border-transparent hover:border-blue-500 text-left"
        >
          <div className="flex items-start gap-4">
            <div className="w-14 h-14 rounded-full bg-blue-100 flex items-center justify-center flex-shrink-0">
              <UserCircle className="w-7 h-7 text-blue-600" />
            </div>
            <div className="flex-1">
              <h3 className="text-lg font-semibold text-gray-900 mb-1">
                Ученик
              </h3>
              <p className="text-sm text-gray-600">
                Просматривайте расписание занятий, свои оценки и контакты преподавателей
              </p>
            </div>
          </div>
        </button>
      </div>

      <div className="px-6 py-4 bg-white border-t border-gray-200">
        <p className="text-xs text-center text-gray-500">
          Демо-версия приложения с тестовыми данными
        </p>
      </div>
    </div>
  );
}
