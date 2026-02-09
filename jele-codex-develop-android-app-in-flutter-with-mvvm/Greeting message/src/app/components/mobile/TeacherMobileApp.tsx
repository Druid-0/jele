import { useState } from 'react';
import { BottomNav } from './BottomNav';
import {
  Users,
  Calendar as CalendarIcon,
  Phone,
  MessageCircle,
  Send,
  ChevronDown,
  BookOpen,
  LogOut,
  Plus,
} from 'lucide-react';
import {
  mockClassGroups,
  mockStudentGrades,
  mockTeacherSchedule,
  mockParentsContacts,
} from '../mockData';

interface TeacherMobileAppProps {
  onLogout: () => void;
}

export function TeacherMobileApp({ onLogout }: TeacherMobileAppProps) {
  const [activeTab, setActiveTab] = useState<'home' | 'schedule' | 'grades' | 'profile'>('home');
  const [selectedClass, setSelectedClass] = useState(mockClassGroups[0]);
  const [showClassSelector, setShowClassSelector] = useState(false);
  const [studentGrades, setStudentGrades] = useState<{ [studentId: string]: number[] }>(
    Object.fromEntries(
      selectedClass.students.map((s) => [s.id, mockStudentGrades(s.id)['Математика'] || []])
    )
  );

  const addGrade = (studentId: string, grade: number) => {
    setStudentGrades((prev) => ({
      ...prev,
      [studentId]: [...(prev[studentId] || []), grade],
    }));
  };

  const calculateAverage = (grades: number[]) => {
    if (grades.length === 0) return 0;
    return grades.reduce((sum, g) => sum + g, 0) / grades.length;
  };

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
      <div className="bg-green-600 px-4 pt-8 pb-4 shadow-md">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h1 className="text-xl font-bold text-white">Преподаватель</h1>
            <p className="text-sm text-green-100">Математика</p>
          </div>
          <button
            onClick={onLogout}
            className="w-9 h-9 rounded-full bg-green-500 flex items-center justify-center"
          >
            <LogOut className="w-5 h-5 text-white" />
          </button>
        </div>
      </div>

      {/* Content */}
      <div className="flex-1 overflow-y-auto pb-16">
        {activeTab === 'home' && (
          <div className="p-4 space-y-4">
            {/* Stats Cards */}
            <div className="grid grid-cols-2 gap-3">
              <div className="bg-white rounded-xl p-4 shadow-sm">
                <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center mb-2">
                  <Users className="w-5 h-5 text-blue-600" />
                </div>
                <p className="text-xs text-gray-600">Учеников</p>
                <p className="text-2xl font-bold text-gray-900">
                  {mockClassGroups.reduce((sum, g) => sum + g.students.length, 0)}
                </p>
              </div>

              <div className="bg-white rounded-xl p-4 shadow-sm">
                <div className="w-10 h-10 rounded-full bg-purple-100 flex items-center justify-center mb-2">
                  <CalendarIcon className="w-5 h-5 text-purple-600" />
                </div>
                <p className="text-xs text-gray-600">Уроков</p>
                <p className="text-2xl font-bold text-gray-900">
                  {mockTeacherSchedule.reduce((sum, s) => sum + s.lessons.length, 0)}
                </p>
              </div>
            </div>

            {/* Classes */}
            <div>
              <h3 className="text-sm font-semibold text-gray-900 mb-3">Мои классы</h3>
              <div className="space-y-2">
                {mockClassGroups.map((classGroup) => (
                  <div key={classGroup.id} className="bg-white rounded-xl p-4 shadow-sm">
                    <div className="flex items-center justify-between">
                      <div>
                        <h4 className="font-semibold text-gray-900">{classGroup.name}</h4>
                        <p className="text-sm text-gray-600">
                          {classGroup.students.length} учеников
                        </p>
                      </div>
                      <div className="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center">
                        <Users className="w-6 h-6 text-green-600" />
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Today's Schedule */}
            <div>
              <h3 className="text-sm font-semibold text-gray-900 mb-3">Сегодня</h3>
              {mockTeacherSchedule[0] && (
                <div className="bg-white rounded-xl p-4 shadow-sm space-y-3">
                  {mockTeacherSchedule[0].lessons.map((lesson, index) => (
                    <div key={index} className="flex gap-3 pb-3 border-b border-gray-100 last:border-0 last:pb-0">
                      <div className="text-center min-w-[60px]">
                        <p className="text-xs font-medium text-green-600">{lesson.time}</p>
                      </div>
                      <div className="flex-1">
                        <p className="font-medium text-gray-900">{lesson.subject}</p>
                        <p className="text-sm text-gray-600">Класс {lesson.teacher}</p>
                        <p className="text-xs text-gray-500">Кабинет {lesson.room}</p>
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
            {mockTeacherSchedule.map((day, index) => (
              <div key={index} className="bg-white rounded-xl shadow-sm overflow-hidden">
                <div className="bg-green-600 px-4 py-2">
                  <h3 className="font-semibold text-white">{day.day}</h3>
                </div>
                <div className="p-4 space-y-3">
                  {day.lessons.map((lesson, lessonIndex) => (
                    <div key={lessonIndex} className="flex gap-3 pb-3 border-b border-gray-100 last:border-0 last:pb-0">
                      <div className="text-center min-w-[60px]">
                        <p className="text-xs font-medium text-green-600">{lesson.time}</p>
                      </div>
                      <div className="flex-1">
                        <p className="font-medium text-gray-900 mb-1">{lesson.subject}</p>
                        <p className="text-sm text-gray-600">Класс {lesson.teacher}</p>
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
          <div className="p-4 space-y-4">
            {/* Class Selector */}
            <button
              onClick={() => setShowClassSelector(!showClassSelector)}
              className="w-full bg-white rounded-xl px-4 py-3 flex items-center justify-between shadow-sm"
            >
              <div className="text-left">
                <p className="text-xs text-gray-600">Выбранный класс</p>
                <p className="font-semibold text-gray-900">{selectedClass.name}</p>
              </div>
              <ChevronDown className={`w-5 h-5 text-gray-600 transition-transform ${showClassSelector ? 'rotate-180' : ''}`} />
            </button>

            {showClassSelector && (
              <div className="bg-white rounded-xl overflow-hidden shadow-sm">
                {mockClassGroups.map((classGroup) => (
                  <button
                    key={classGroup.id}
                    onClick={() => {
                      setSelectedClass(classGroup);
                      setShowClassSelector(false);
                      setStudentGrades(
                        Object.fromEntries(
                          classGroup.students.map((s) => [
                            s.id,
                            mockStudentGrades(s.id)['Математика'] || [],
                          ])
                        )
                      );
                    }}
                    className={`w-full px-4 py-3 text-left hover:bg-gray-50 ${
                      selectedClass.id === classGroup.id ? 'bg-green-50' : ''
                    }`}
                  >
                    <p className="font-medium text-gray-900">{classGroup.name}</p>
                    <p className="text-sm text-gray-600">{classGroup.students.length} учеников</p>
                  </button>
                ))}
              </div>
            )}

            {/* Students List */}
            <div className="space-y-3">
              {selectedClass.students.map((student) => {
                const grades = studentGrades[student.id] || [];
                const average = calculateAverage(grades);

                return (
                  <div key={student.id} className="bg-white rounded-xl p-4 shadow-sm">
                    <div className="flex items-start justify-between mb-3">
                      <div>
                        <h4 className="font-semibold text-gray-900">{student.name}</h4>
                        <p className="text-xs text-gray-600">{student.class}</p>
                      </div>
                      <span className={`text-lg font-bold ${getAverageColorClass(average)}`}>
                        {average > 0 ? average.toFixed(2) : '-'}
                      </span>
                    </div>

                    <div className="flex flex-wrap gap-2 mb-3">
                      {grades.map((grade, index) => (
                        <div
                          key={index}
                          className={`w-8 h-8 rounded flex items-center justify-center text-sm font-semibold ${getGradeColor(grade)}`}
                        >
                          {grade}
                        </div>
                      ))}
                    </div>

                    <div className="flex gap-2">
                      {[5, 4, 3, 2].map((grade) => (
                        <button
                          key={grade}
                          onClick={() => addGrade(student.id, grade)}
                          className={`flex-1 h-9 rounded-lg font-semibold ${getGradeColor(grade)} hover:opacity-80 transition-opacity`}
                        >
                          {grade}
                        </button>
                      ))}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {activeTab === 'profile' && (
          <div className="p-4 space-y-3">
            <h2 className="text-lg font-semibold text-gray-900 mb-3">Родители</h2>
            {mockParentsContacts.map((contact, index) => (
              <div key={index} className="bg-white rounded-xl p-4 shadow-sm">
                <div className="mb-3">
                  <h4 className="font-semibold text-gray-900">{contact.name}</h4>
                  <p className="text-sm text-gray-600">{contact.role}</p>
                </div>
                <div className="space-y-2">
                  <a
                    href={`tel:${contact.phone}`}
                    className="flex items-center gap-3 p-2 rounded-lg bg-gray-50"
                  >
                    <div className="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center">
                      <Phone className="w-4 h-4 text-blue-600" />
                    </div>
                    <span className="text-sm text-gray-900">{contact.phone}</span>
                  </a>
                  <a
                    href={`https://wa.me/${contact.whatsapp}`}
                    className="flex items-center gap-3 p-2 rounded-lg bg-green-50"
                  >
                    <div className="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center">
                      <MessageCircle className="w-4 h-4 text-green-600" />
                    </div>
                    <span className="text-sm text-gray-900">WhatsApp</span>
                  </a>
                  <a
                    href={`https://t.me/${contact.telegram.replace('@', '')}`}
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
