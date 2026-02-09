import { useState } from 'react';
import { LogOut, BookOpen, Calendar, Users, Phone } from 'lucide-react';
import { ScheduleCard } from './ScheduleCard';
import { ContactCard } from './ContactCard';
import {
  mockClassGroups,
  mockStudentGrades,
  mockTeacherSchedule,
  mockParentsContacts,
} from './mockData';

interface TeacherDashboardProps {
  onLogout: () => void;
}

export function TeacherDashboard({ onLogout }: TeacherDashboardProps) {
  const [selectedClass, setSelectedClass] = useState(mockClassGroups[0]);
  const [activeTab, setActiveTab] = useState<'journal' | 'schedule' | 'contacts'>('journal');
  const [studentGrades, setStudentGrades] = useState<{ [studentId: string]: number[] }>(
    Object.fromEntries(
      selectedClass.students.map((s) => [
        s.id,
        mockStudentGrades(s.id)['Математика'] || [],
      ])
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

  const getAverageColor = (avg: number) => {
    if (avg >= 4.5) return 'text-green-600';
    if (avg >= 3.5) return 'text-blue-600';
    if (avg >= 2.5) return 'text-yellow-600';
    return 'text-red-600';
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-full bg-green-600 flex items-center justify-center">
                <BookOpen className="w-6 h-6 text-white" />
              </div>
              <div>
                <h1 className="text-xl font-semibold text-gray-900">
                  Личный кабинет преподавателя
                </h1>
                <p className="text-sm text-gray-600">Математика</p>
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
              <div className="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                <Users className="w-6 h-6 text-blue-600" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Всего учеников</p>
                <p className="text-2xl font-bold text-gray-900">
                  {mockClassGroups.reduce((sum, g) => sum + g.students.length, 0)}
                </p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-full bg-purple-100 flex items-center justify-center">
                <Calendar className="w-6 h-6 text-purple-600" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Уроков в неделю</p>
                <p className="text-2xl font-bold text-gray-900">
                  {mockTeacherSchedule.reduce((sum, s) => sum + s.lessons.length, 0)}
                </p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center">
                <Phone className="w-6 h-6 text-green-600" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Контактов родителей</p>
                <p className="text-2xl font-bold text-gray-900">
                  {mockParentsContacts.length}
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
                onClick={() => setActiveTab('journal')}
                className={`px-6 py-4 font-medium border-b-2 transition-colors ${
                  activeTab === 'journal'
                    ? 'border-green-600 text-green-600'
                    : 'border-transparent text-gray-600 hover:text-gray-900 hover:border-gray-300'
                }`}
              >
                Электронный журнал
              </button>
              <button
                onClick={() => setActiveTab('schedule')}
                className={`px-6 py-4 font-medium border-b-2 transition-colors ${
                  activeTab === 'schedule'
                    ? 'border-green-600 text-green-600'
                    : 'border-transparent text-gray-600 hover:text-gray-900 hover:border-gray-300'
                }`}
              >
                Расписание
              </button>
              <button
                onClick={() => setActiveTab('contacts')}
                className={`px-6 py-4 font-medium border-b-2 transition-colors ${
                  activeTab === 'contacts'
                    ? 'border-green-600 text-green-600'
                    : 'border-transparent text-gray-600 hover:text-gray-900 hover:border-gray-300'
                }`}
              >
                Контакты родителей
              </button>
            </nav>
          </div>
        </div>

        {/* Content */}
        {activeTab === 'journal' && (
          <div>
            {/* Class Selector */}
            <div className="mb-6">
              <h2 className="text-lg font-semibold text-gray-900 mb-4">Выберите класс</h2>
              <div className="flex flex-wrap gap-4">
                {mockClassGroups.map((classGroup) => (
                  <button
                    key={classGroup.id}
                    onClick={() => {
                      setSelectedClass(classGroup);
                      setStudentGrades(
                        Object.fromEntries(
                          classGroup.students.map((s) => [
                            s.id,
                            mockStudentGrades(s.id)['Математика'] || [],
                          ])
                        )
                      );
                    }}
                    className={`px-6 py-3 rounded-lg font-medium transition-all ${
                      selectedClass.id === classGroup.id
                        ? 'bg-green-600 text-white shadow-md'
                        : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                    }`}
                  >
                    {classGroup.name}
                  </button>
                ))}
              </div>
            </div>

            {/* Journal Table */}
            <div className="bg-white rounded-lg shadow-md overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead className="bg-gray-50 border-b border-gray-200">
                    <tr>
                      <th className="px-6 py-4 text-left text-sm font-semibold text-gray-900">
                        Ученик
                      </th>
                      <th className="px-6 py-4 text-left text-sm font-semibold text-gray-900">
                        Оценки
                      </th>
                      <th className="px-6 py-4 text-center text-sm font-semibold text-gray-900">
                        Средний балл
                      </th>
                      <th className="px-6 py-4 text-center text-sm font-semibold text-gray-900">
                        Действия
                      </th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-200">
                    {selectedClass.students.map((student) => {
                      const grades = studentGrades[student.id] || [];
                      const average = calculateAverage(grades);

                      return (
                        <tr key={student.id} className="hover:bg-gray-50">
                          <td className="px-6 py-4">
                            <div className="font-medium text-gray-900">{student.name}</div>
                            <div className="text-sm text-gray-600">{student.class}</div>
                          </td>
                          <td className="px-6 py-4">
                            <div className="flex flex-wrap gap-2">
                              {grades.map((grade, index) => (
                                <div
                                  key={index}
                                  className={`w-8 h-8 rounded flex items-center justify-center text-sm font-semibold ${getGradeColor(
                                    grade
                                  )}`}
                                >
                                  {grade}
                                </div>
                              ))}
                            </div>
                          </td>
                          <td className="px-6 py-4 text-center">
                            <span
                              className={`text-lg font-bold ${getAverageColor(average)}`}
                            >
                              {average > 0 ? average.toFixed(2) : '-'}
                            </span>
                          </td>
                          <td className="px-6 py-4">
                            <div className="flex justify-center gap-2">
                              {[5, 4, 3, 2].map((grade) => (
                                <button
                                  key={grade}
                                  onClick={() => addGrade(student.id, grade)}
                                  className={`w-8 h-8 rounded font-semibold transition-all hover:scale-110 ${getGradeColor(
                                    grade
                                  )}`}
                                >
                                  {grade}
                                </button>
                              ))}
                            </div>
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        )}

        {activeTab === 'schedule' && (
          <div>
            <h2 className="text-xl font-semibold text-gray-900 mb-6">Расписание уроков</h2>
            <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
              {mockTeacherSchedule.map((day, index) => (
                <ScheduleCard key={index} day={day.day} lessons={day.lessons} />
              ))}
            </div>
          </div>
        )}

        {activeTab === 'contacts' && (
          <div>
            <h2 className="text-xl font-semibold text-gray-900 mb-6">
              Контакты родителей
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {mockParentsContacts.map((contact, index) => (
                <ContactCard
                  key={index}
                  name={contact.name}
                  role={contact.role}
                  phone={contact.phone}
                  whatsapp={contact.whatsapp}
                  telegram={contact.telegram}
                />
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
