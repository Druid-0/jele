import { useState } from 'react';
import { BottomNav } from './BottomNav';
import {
  TrendingUp,
  Calendar as CalendarIcon,
  Phone,
  MessageCircle,
  Send,
  ChevronDown,
  Award,
  BookOpen,
  LogOut,
  Menu,
} from 'lucide-react';
import {
  mockChildren,
  mockGradesForChild,
  mockScheduleForChild,
  mockTeachersForParent,
} from '../mockData';

interface ParentMobileAppProps {
  onLogout: () => void;
}

export function ParentMobileApp({ onLogout }: ParentMobileAppProps) {
  const [activeTab, setActiveTab] = useState<'home' | 'schedule' | 'grades' | 'profile'>('home');
  const [selectedChild, setSelectedChild] = useState(mockChildren[0]);
  const [showChildSelector, setShowChildSelector] = useState(false);

  const grades = mockGradesForChild(selectedChild.id);
  const schedule = mockScheduleForChild(selectedChild.id);
  const overallAverage = grades.reduce((sum, g) => sum + g.average, 0) / grades.length;

  const getGradeColor = (grade: number) => {
    if (grade === 5) return 'bg-green-500 text-white';
    if (grade === 4) return 'bg-blue-500 text-white';
    if (grade === 3) return 'bg-yellow-500 text-white';
    return 'bg-red-500 text-white';
  };

  const getAverageColorClass = (avg: number) => {
    if (avg >= 4.5) return 'text-green-600';
    if (avg >= 3.5) return 'text-blue-600';
    if (avg >= 2.5) return 'text-yellow-600';
    return 'text-red-600';
  };

  return (
    <div className="h-full flex flex-col bg-gray-50">
      {/* Header */}
      <div className="bg-blue-600 px-4 pt-8 pb-4 shadow-md">
        <div className="flex items-center justify-between mb-4">
          <h1 className="text-xl font-bold text-white">Родитель</h1>
          <button
            onClick={onLogout}
            className="w-9 h-9 rounded-full bg-blue-500 flex items-center justify-center"
          >
            <LogOut className="w-5 h-5 text-white" />
          </button>
        </div>

        {/* Child Selector */}
        <button
          onClick={() => setShowChildSelector(!showChildSelector)}
          className="w-full bg-blue-500 rounded-xl px-4 py-3 flex items-center justify-between text-white"
        >
          <div className="text-left">
            <p className="text-xs text-blue-100">Выбранный ребенок</p>
            <p className="font-semibold">{selectedChild.name}</p>
            <p className="text-xs text-blue-100">Класс {selectedChild.class}</p>
          </div>
          <ChevronDown className={`w-5 h-5 transition-transform ${showChildSelector ? 'rotate-180' : ''}`} />
        </button>

        {showChildSelector && (
          <div className="mt-2 bg-white rounded-xl overflow-hidden shadow-lg">
            {mockChildren.map((child) => (
              <button
                key={child.id}
                onClick={() => {
                  setSelectedChild(child);
                  setShowChildSelector(false);
                }}
                className={`w-full px-4 py-3 text-left hover:bg-gray-50 ${
                  selectedChild.id === child.id ? 'bg-blue-50' : ''
                }`}
              >
                <p className="font-medium text-gray-900">{child.name}</p>
                <p className="text-sm text-gray-600">Класс {child.class}</p>
              </button>
            ))}
          </div>
        )}
      </div>

      {/* Content */}
      <div className="flex-1 overflow-y-auto pb-16">
        {activeTab === 'home' && (
          <div className="p-4 space-y-4">
            {/* Stats Cards */}
            <div className="grid grid-cols-2 gap-3">
              <div className="bg-white rounded-xl p-4 shadow-sm">
                <div className="w-10 h-10 rounded-full bg-green-100 flex items-center justify-center mb-2">
                  <Award className="w-5 h-5 text-green-600" />
                </div>
                <p className="text-xs text-gray-600">Средний балл</p>
                <p className="text-2xl font-bold text-green-600">
                  {overallAverage.toFixed(1)}
                </p>
              </div>

              <div className="bg-white rounded-xl p-4 shadow-sm">
                <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center mb-2">
                  <BookOpen className="w-5 h-5 text-blue-600" />
                </div>
                <p className="text-xs text-gray-600">Предметов</p>
                <p className="text-2xl font-bold text-gray-900">{grades.length}</p>
              </div>
            </div>

            {/* Recent Grades */}
            <div>
              <h3 className="text-sm font-semibold text-gray-900 mb-3">Последние оценки</h3>
              <div className="space-y-2">
                {grades.slice(0, 3).map((grade, index) => (
                  <div key={index} className="bg-white rounded-xl p-4 shadow-sm">
                    <div className="flex items-center justify-between mb-2">
                      <h4 className="font-medium text-gray-900">{grade.subject}</h4>
                      <span className={`text-lg font-bold ${getAverageColorClass(grade.average)}`}>
                        {grade.average.toFixed(1)}
                      </span>
                    </div>
                    <div className="flex gap-1">
                      {grade.grades.slice(-5).map((g, i) => (
                        <div
                          key={i}
                          className={`w-7 h-7 rounded flex items-center justify-center text-xs font-semibold ${getGradeColor(g)}`}
                        >
                          {g}
                        </div>
                      ))}
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Today's Schedule */}
            <div>
              <h3 className="text-sm font-semibold text-gray-900 mb-3">Расписание на сегодня</h3>
              {schedule[0] && (
                <div className="bg-white rounded-xl p-4 shadow-sm space-y-3">
                  {schedule[0].lessons.slice(0, 2).map((lesson, index) => (
                    <div key={index} className="flex gap-3">
                      <div className="text-center">
                        <p className="text-xs font-medium text-blue-600">
                          {lesson.time.split(' - ')[0]}
                        </p>
                      </div>
                      <div className="flex-1">
                        <p className="font-medium text-gray-900">{lesson.subject}</p>
                        <p className="text-xs text-gray-600">{lesson.teacher}</p>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        )}

        {activeTab === 'schedule' && (
          <div className="p-4 space-y-3">
            <h2 className="text-lg font-semibold text-gray-900">Расписание</h2>
            {schedule.map((day, index) => (
              <div key={index} className="bg-white rounded-xl shadow-sm overflow-hidden">
                <div className="bg-blue-600 px-4 py-2">
                  <h3 className="font-semibold text-white">{day.day}</h3>
                </div>
                <div className="p-4 space-y-3">
                  {day.lessons.map((lesson, lessonIndex) => (
                    <div key={lessonIndex} className="flex gap-3 pb-3 border-b border-gray-100 last:border-0 last:pb-0">
                      <div className="text-center min-w-[60px]">
                        <p className="text-xs font-medium text-blue-600">{lesson.time}</p>
                      </div>
                      <div className="flex-1">
                        <p className="font-medium text-gray-900 mb-1">{lesson.subject}</p>
                        <p className="text-xs text-gray-600">{lesson.teacher}</p>
                        <p className="text-xs text-gray-500">Кабинет {lesson.room}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        )}

        {activeTab === 'grades' && (
          <div className="p-4 space-y-3">
            <h2 className="text-lg font-semibold text-gray-900">Оценки</h2>
            {grades.map((grade, index) => (
              <div key={index} className="bg-white rounded-xl p-4 shadow-sm">
                <div className="flex items-center justify-between mb-3">
                  <h4 className="font-semibold text-gray-900">{grade.subject}</h4>
                  <div className="flex items-center gap-2">
                    <span className={`text-xl font-bold ${getAverageColorClass(grade.average)}`}>
                      {grade.average.toFixed(2)}
                    </span>
                    <TrendingUp className="w-4 h-4 text-green-600" />
                  </div>
                </div>
                <div className="flex flex-wrap gap-2">
                  {grade.grades.map((g, i) => (
                    <div
                      key={i}
                      className={`w-9 h-9 rounded flex items-center justify-center font-semibold ${getGradeColor(g)}`}
                    >
                      {g}
                    </div>
                  ))}
                </div>
                <p className="text-xs text-gray-600 mt-3">Всего оценок: {grade.grades.length}</p>
              </div>
            ))}
          </div>
        )}

        {activeTab === 'profile' && (
          <div className="p-4 space-y-3">
            <h2 className="text-lg font-semibold text-gray-900 mb-3">Преподаватели</h2>
            {mockTeachersForParent.map((teacher, index) => (
              <div key={index} className="bg-white rounded-xl p-4 shadow-sm">
                <div className="mb-3">
                  <h4 className="font-semibold text-gray-900">{teacher.name}</h4>
                  <p className="text-sm text-blue-600">{teacher.subject}</p>
                </div>
                <div className="space-y-2">
                  <a
                    href={`tel:${teacher.phone}`}
                    className="flex items-center gap-3 p-2 rounded-lg bg-gray-50"
                  >
                    <div className="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center">
                      <Phone className="w-4 h-4 text-blue-600" />
                    </div>
                    <span className="text-sm text-gray-900">{teacher.phone}</span>
                  </a>
                  <a
                    href={`https://wa.me/${teacher.whatsapp}`}
                    className="flex items-center gap-3 p-2 rounded-lg bg-green-50"
                  >
                    <div className="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center">
                      <MessageCircle className="w-4 h-4 text-green-600" />
                    </div>
                    <span className="text-sm text-gray-900">WhatsApp</span>
                  </a>
                  <a
                    href={`https://t.me/${teacher.telegram.replace('@', '')}`}
                    className="flex items-center gap-3 p-2 rounded-lg bg-blue-50"
                  >
                    <div className="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center">
                      <Send className="w-4 h-4 text-blue-600" />
                    </div>
                    <span className="text-sm text-gray-900">Telegram</span>
                  </a>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Bottom Navigation */}
      <div className="absolute bottom-0 left-0 right-0 bg-white border-t border-gray-200">
        <BottomNav activeTab={activeTab} onTabChange={setActiveTab} />
      </div>
    </div>
  );
}
