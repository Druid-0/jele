import { UserCircle, BookOpen, Users } from 'lucide-react';

interface LoginPageProps {
  onSelectRole: (role: 'parent' | 'teacher' | 'student') => void;
}

export function LoginPage({ onSelectRole }: LoginPageProps) {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-4">
      <div className="w-full max-w-4xl">
        <div className="text-center mb-12">
          <div className="inline-flex items-center justify-center w-16 h-16 bg-indigo-600 rounded-full mb-4">
            <BookOpen className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-4xl font-bold text-gray-900 mb-2">EduPlatform</h1>
          <p className="text-lg text-gray-600">Автоматизация процессов обучения</p>
        </div>

        <div className="bg-white rounded-2xl shadow-xl p-8">
          <h2 className="text-2xl font-semibold text-center mb-8 text-gray-800">
            Выберите вашу роль
          </h2>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {/* Родитель */}
            <button
              onClick={() => onSelectRole('parent')}
              className="group p-8 rounded-xl border-2 border-gray-200 hover:border-indigo-500 hover:shadow-lg transition-all duration-200 bg-white hover:bg-indigo-50"
            >
              <div className="flex flex-col items-center text-center">
                <div className="w-16 h-16 rounded-full bg-indigo-100 group-hover:bg-indigo-200 flex items-center justify-center mb-4 transition-colors">
                  <Users className="w-8 h-8 text-indigo-600" />
                </div>
                <h3 className="text-xl font-semibold text-gray-900 mb-2">Родитель</h3>
                <p className="text-sm text-gray-600">
                  Отслеживайте успеваемость детей и общайтесь с преподавателями
                </p>
              </div>
            </button>

            {/* Преподаватель */}
            <button
              onClick={() => onSelectRole('teacher')}
              className="group p-8 rounded-xl border-2 border-gray-200 hover:border-green-500 hover:shadow-lg transition-all duration-200 bg-white hover:bg-green-50"
            >
              <div className="flex flex-col items-center text-center">
                <div className="w-16 h-16 rounded-full bg-green-100 group-hover:bg-green-200 flex items-center justify-center mb-4 transition-colors">
                  <BookOpen className="w-8 h-8 text-green-600" />
                </div>
                <h3 className="text-xl font-semibold text-gray-900 mb-2">Преподаватель</h3>
                <p className="text-sm text-gray-600">
                  Управляйте расписанием и выставляйте оценки ученикам
                </p>
              </div>
            </button>

            {/* Ученик */}
            <button
              onClick={() => onSelectRole('student')}
              className="group p-8 rounded-xl border-2 border-gray-200 hover:border-blue-500 hover:shadow-lg transition-all duration-200 bg-white hover:bg-blue-50"
            >
              <div className="flex flex-col items-center text-center">
                <div className="w-16 h-16 rounded-full bg-blue-100 group-hover:bg-blue-200 flex items-center justify-center mb-4 transition-colors">
                  <UserCircle className="w-8 h-8 text-blue-600" />
                </div>
                <h3 className="text-xl font-semibold text-gray-900 mb-2">Ученик</h3>
                <p className="text-sm text-gray-600">
                  Просматривайте расписание, оценки и контакты преподавателей
                </p>
              </div>
            </button>
          </div>
        </div>

        <p className="text-center text-sm text-gray-600 mt-6">
          Демо-версия платформы с тестовыми данными
        </p>
      </div>
    </div>
  );
}
