import { Clock, MapPin, User } from 'lucide-react';

interface Lesson {
  time: string;
  subject: string;
  teacher: string;
  room: string;
}

interface ScheduleCardProps {
  day: string;
  lessons: Lesson[];
}

export function ScheduleCard({ day, lessons }: ScheduleCardProps) {
  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden">
      <div className="bg-gradient-to-r from-indigo-600 to-blue-500 px-6 py-4">
        <h3 className="font-semibold text-white text-lg">{day}</h3>
      </div>

      <div className="p-6 space-y-4">
        {lessons.map((lesson, index) => (
          <div
            key={index}
            className="flex gap-4 p-4 rounded-lg border border-gray-200 hover:border-indigo-300 hover:bg-indigo-50 transition-all"
          >
            <div className="flex flex-col items-center justify-center min-w-[80px] text-center">
              <Clock className="w-5 h-5 text-indigo-600 mb-1" />
              <span className="text-sm font-medium text-gray-900 whitespace-nowrap">
                {lesson.time}
              </span>
            </div>

            <div className="flex-1 min-w-0">
              <h4 className="font-semibold text-gray-900 mb-2">{lesson.subject}</h4>
              <div className="flex flex-col sm:flex-row sm:items-center gap-2 sm:gap-4 text-sm text-gray-600">
                <div className="flex items-center gap-1">
                  <User className="w-4 h-4" />
                  <span className="truncate">{lesson.teacher}</span>
                </div>
                <div className="flex items-center gap-1">
                  <MapPin className="w-4 h-4" />
                  <span>Каб. {lesson.room}</span>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
