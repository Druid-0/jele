import { useState } from 'react';
import { BookOpen, Mail, Lock, ArrowRight } from 'lucide-react';

interface LoginScreenProps {
  onLogin: () => void;
}

export function LoginScreen({ onLogin }: LoginScreenProps) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onLogin();
  };

  return (
    <div className="h-full bg-gradient-to-b from-blue-600 to-blue-800 flex flex-col">
      {/* Top Section */}
      <div className="flex-1 flex flex-col items-center justify-center px-6 pt-12">
        <div className="w-20 h-20 bg-white rounded-full flex items-center justify-center mb-4 shadow-lg">
          <BookOpen className="w-10 h-10 text-blue-600" />
        </div>
        <h1 className="text-3xl font-bold text-white mb-2">EduPlatform</h1>
        <p className="text-blue-100 text-center">
          Образовательная платформа
        </p>
      </div>

      {/* Login Form */}
      <div className="bg-white rounded-t-3xl px-6 pt-8 pb-6">
        <h2 className="text-2xl font-bold text-gray-900 mb-6">Вход</h2>
        
        <form onSubmit={handleSubmit} className="space-y-4">
          {/* Email Input */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Email
            </label>
            <div className="relative">
              <div className="absolute left-3 top-1/2 -translate-y-1/2">
                <Mail className="w-5 h-5 text-gray-400" />
              </div>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="username@email.com"
                className="w-full pl-11 pr-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
          </div>

          {/* Password Input */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Пароль
            </label>
            <div className="relative">
              <div className="absolute left-3 top-1/2 -translate-y-1/2">
                <Lock className="w-5 h-5 text-gray-400" />
              </div>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
                className="w-full pl-11 pr-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
          </div>

          {/* Forgot Password */}
          <div className="text-right">
            <button type="button" className="text-sm text-blue-600 font-medium">
              Забыли пароль?
            </button>
          </div>

          {/* Submit Button */}
          <button
            type="submit"
            className="w-full bg-blue-600 text-white py-3 rounded-xl font-semibold flex items-center justify-center gap-2 hover:bg-blue-700 transition-colors shadow-lg shadow-blue-600/30"
          >
            Войти
            <ArrowRight className="w-5 h-5" />
          </button>
        </form>

        <div className="mt-6 text-center">
          <p className="text-sm text-gray-600">
            Нет аккаунта?{' '}
            <button className="text-blue-600 font-semibold">
              Зарегистрироваться
            </button>
          </p>
        </div>
      </div>
    </div>
  );
}
