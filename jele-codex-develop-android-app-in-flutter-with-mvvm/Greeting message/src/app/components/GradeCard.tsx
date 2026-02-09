import { TrendingUp, TrendingDown, Minus } from 'lucide-react';

interface GradeCardProps {
  subject: string;
  grades: number[];
  average: number;
}

export function GradeCard({ subject, grades, average }: GradeCardProps) {
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

  const getTrend = () => {
    if (grades.length < 2) return null;
    const recent = grades.slice(-3);
    const earlier = grades.slice(0, -3);
    if (earlier.length === 0) return null;
    
    const recentAvg = recent.reduce((a, b) => a + b, 0) / recent.length;
    const earlierAvg = earlier.reduce((a, b) => a + b, 0) / earlier.length;
    
    if (recentAvg > earlierAvg) return 'up';
    if (recentAvg < earlierAvg) return 'down';
    return 'stable';
  };

  const trend = getTrend();

  return (
    <div className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow">
      <div className="flex justify-between items-start mb-4">
        <h3 className="font-semibold text-gray-900">{subject}</h3>
        <div className="flex items-center gap-2">
          <span className={`text-2xl font-bold ${getAverageColor(average)}`}>
            {average.toFixed(2)}
          </span>
          {trend === 'up' && <TrendingUp className="w-5 h-5 text-green-600" />}
          {trend === 'down' && <TrendingDown className="w-5 h-5 text-red-600" />}
          {trend === 'stable' && <Minus className="w-5 h-5 text-gray-400" />}
        </div>
      </div>

      <div className="flex flex-wrap gap-2">
        {grades.map((grade, index) => (
          <div
            key={index}
            className={`w-10 h-10 rounded-lg flex items-center justify-center font-semibold ${getGradeColor(grade)}`}
          >
            {grade}
          </div>
        ))}
      </div>

      <div className="mt-4 text-sm text-gray-600">
        Всего оценок: {grades.length}
      </div>
    </div>
  );
}
