import { useState } from 'react';
import { LogOut, Users, GraduationCap, BookOpen, Phone } from 'lucide-react';
import { GradeCard } from './GradeCard';
import { ScheduleCard } from './ScheduleCard';
import { ContactCard } from './ContactCard';
import {
  mockChildren,
  mockGradesForChild,
  mockScheduleForChild,
  mockTeachersForParent,
} from './mockData';

interface ParentDashboardProps {
  onLogout: () => void;
}

export function ParentDashboard({ onLogout }: ParentDashboardProps) {
  const [selectedChild, setSelectedChild] = useState(mockChildren[0]);
  const [activeTab, setActiveTab] = useState<'grades' | 'schedule' | 'teachers'>('grades');

  const grades = mockGradesForChild(selectedChild.id);
  const schedule = mockScheduleForChild(selectedChild.id);

  const overallAverage =
    grades.reduce((sum, g) => sum + g.average, 0) / grades.length;

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-full bg-indigo-600 flex items-center justify-center">
                <Users className="w-6 h-6 text-white" />
              </div>
              <div>
                <h1 className="text-xl font-semibold text-gray-900">
                  Личный кабинет родителя
                </h1>
                <p className="text-sm text-gray-600">EduPlatform</p>
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
        {/* Child Selector */}
        <div className="mb-8">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Выберите ребенка</h2>
          <div className="flex flex-wrap gap-4">
            {mockChildren.map((child) => (
              <button
                key={child.id}
                onClick={() => setSelectedChild(child)}
                className={`px-6 py-3 rounded-lg font-medium transition-all ${
                  selectedChild.id === child.id
                    ? 'bg-indigo-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                {child.name} ({child.class})
              </button>
            ))}
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center">
                <GraduationCap className="w-6 h-6 text-green-600" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Средний балл</p>
                <p className="text-2xl font-bold text-gray-900">
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
                <p className="text-2xl font-bold text-gray-900">{grades.length}</p>
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
                  {mockTeachersForParent.length}
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
                    ? 'border-indigo-600 text-indigo-600'
                    : 'border-transparent text-gray-600 hover:text-gray-900 hover:border-gray-300'
                }`}
              >
                Оценки
              </button>
              <button
                onClick={() => setActiveTab('schedule')}
                className={`px-6 py-4 font-medium border-b-2 transition-colors ${
                  activeTab === 'schedule'
                    ? 'border-indigo-600 text-indigo-600'
                    : 'border-transparent text-gray-600 hover:text-gray-900 hover:border-gray-300'
                }`}
              >
                Расписание
              </button>
              <button
                onClick={() => setActiveTab('teachers')}
                className={`px-6 py-4 font-medium border-b-2 transition-colors ${
                  activeTab === 'teachers'
                    ? 'border-indigo-600 text-indigo-600'
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
              Оценки по предметам
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {grades.map((grade, index) => (
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
              Расписание занятий
            </h2>
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              {schedule.map((day, index) => (
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
              {mockTeachersForParent.map((teacher, index) => (
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
