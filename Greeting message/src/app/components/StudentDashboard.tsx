import { useState } from 'react';
import { LogOut, UserCircle, GraduationCap, BookOpen, Phone } from 'lucide-react';
import { GradeCard } from './GradeCard';
import { ScheduleCard } from './ScheduleCard';
import { ContactCard } from './ContactCard';
import {
  mockStudentInfo,
  mockStudentGradesData,
  mockStudentSchedule,
  mockTeachersForStudent,
} from './mockData';

interface StudentDashboardProps {
  onLogout: () => void;
}

export function StudentDashboard({ onLogout }: StudentDashboardProps) {
  const [activeTab, setActiveTab] = useState<'grades' | 'schedule' | 'teachers'>('grades');

  const overallAverage =
    mockStudentGradesData.reduce((sum, g) => sum + g.average, 0) /
    mockStudentGradesData.length;

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-full bg-blue-600 flex items-center justify-center">
                <UserCircle className="w-6 h-6 text-white" />
              </div>
              <div>
                <h1 className="text-xl font-semibold text-gray-900">
                  {mockStudentInfo.name}
                </h1>
                <p className="text-sm text-gray-600">
                  Класс {mockStudentInfo.class}
                </p>
              </div>
            </div>
            <button
              onClick={onLogout}
              className="flex items-center gap-2 px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg transition-colors"
            >
              <LogOut className="w-5 h-5" />
              <span className="hidden sm:inline">Выйти</span>
            </button>
          </div>
        </div>
      </header>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center">
                <GraduationCap className="w-6 h-6 text-green-600" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Средний балл</p>
                <p className="text-2xl font-bold text-green-600">
                  {overallAverage.toFixed(2)}
                </p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                <BookOpen className="w-6 h-6 text-blue-600" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Предметов</p>
                <p className="text-2xl font-bold text-gray-900">
                  {mockStudentGradesData.length}
                </p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-full bg-purple-100 flex items-center justify-center">
                <Phone className="w-6 h-6 text-purple-600" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Преподавателей</p>
                <p className="text-2xl font-bold text-gray-900">
                  {mockTeachersForStudent.length}
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Tabs */}
        <div className="bg-white rounded-lg shadow-sm mb-6">
          <div className="border-b border-gray-200">
            <nav className="flex -mb-px">
              <button
                onClick={() => setActiveTab('grades')}
                className={`px-6 py-4 font-medium border-b-2 transition-colors ${
                  activeTab === 'grades'
                    ? 'border-blue-600 text-blue-600'
                    : 'border-transparent text-gray-600 hover:text-gray-900 hover:border-gray-300'
                }`}
              >
                Мои оценки
              </button>
              <button
                onClick={() => setActiveTab('schedule')}
                className={`px-6 py-4 font-medium border-b-2 transition-colors ${
                  activeTab === 'schedule'
                    ? 'border-blue-600 text-blue-600'
                    : 'border-transparent text-gray-600 hover:text-gray-900 hover:border-gray-300'
                }`}
              >
                Расписание
              </button>
              <button
                onClick={() => setActiveTab('teachers')}
                className={`px-6 py-4 font-medium border-b-2 transition-colors ${
                  activeTab === 'teachers'
                    ? 'border-blue-600 text-blue-600'
                    : 'border-transparent text-gray-600 hover:text-gray-900 hover:border-gray-300'
                }`}
              >
                Преподаватели
              </button>
            </nav>
          </div>
        </div>

        {/* Content */}
        {activeTab === 'grades' && (
          <div>
            <h2 className="text-xl font-semibold text-gray-900 mb-6">
              Мои оценки по предметам
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {mockStudentGradesData.map((grade, index) => (
                <GradeCard
                  key={index}
                  subject={grade.subject}
                  grades={grade.grades}
                  average={grade.average}
                />
              ))}
            </div>
          </div>
        )}

        {activeTab === 'schedule' && (
          <div>
            <h2 className="text-xl font-semibold text-gray-900 mb-6">
              Мое расписание
            </h2>
            <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
              {mockStudentSchedule.map((day, index) => (
                <ScheduleCard key={index} day={day.day} lessons={day.lessons} />
              ))}
            </div>
          </div>
        )}

        {activeTab === 'teachers' && (
          <div>
            <h2 className="text-xl font-semibold text-gray-900 mb-6">
              Контакты преподавателей
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {mockTeachersForStudent.map((teacher, index) => (
                <ContactCard
                  key={index}
                  name={teacher.name}
                  role={teacher.role}
                  subject={teacher.subject}
                  phone={teacher.phone}
                  whatsapp={teacher.whatsapp}
                  telegram={teacher.telegram}
                />
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
