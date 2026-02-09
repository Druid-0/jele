import { Phone, MessageCircle, Send } from 'lucide-react';

interface ContactCardProps {
  name: string;
  role: string;
  subject?: string;
  phone: string;
  whatsapp: string;
  telegram: string;
}

export function ContactCard({ name, role, subject, phone, whatsapp, telegram }: ContactCardProps) {
  return (
    <div className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow">
      <div className="mb-4">
        <h3 className="font-semibold text-gray-900 text-lg">{name}</h3>
        <p className="text-sm text-gray-600">{role}</p>
        {subject && (
          <p className="text-sm font-medium text-indigo-600 mt-1">{subject}</p>
        )}
      </div>

      <div className="space-y-3">
        <a
          href={`tel:${phone}`}
          className="flex items-center gap-3 p-3 rounded-lg bg-gray-50 hover:bg-gray-100 transition-colors"
        >
          <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center">
            <Phone className="w-5 h-5 text-blue-600" />
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-xs text-gray-600">Телефон</p>
            <p className="font-medium text-gray-900">{phone}</p>
          </div>
        </a>

        <a
          href={`https://wa.me/${whatsapp}`}
          target="_blank"
          rel="noopener noreferrer"
          className="flex items-center gap-3 p-3 rounded-lg bg-green-50 hover:bg-green-100 transition-colors"
        >
          <div className="w-10 h-10 rounded-full bg-green-100 flex items-center justify-center">
            <MessageCircle className="w-5 h-5 text-green-600" />
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-xs text-gray-600">WhatsApp</p>
            <p className="font-medium text-gray-900">{whatsapp}</p>
          </div>
        </a>

        <a
          href={`https://t.me/${telegram.replace('@', '')}`}
          target="_blank"
          rel="noopener noreferrer"
          className="flex items-center gap-3 p-3 rounded-lg bg-blue-50 hover:bg-blue-100 transition-colors"
        >
          <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center">
            <Send className="w-5 h-5 text-blue-600" />
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-xs text-gray-600">Telegram</p>
            <p className="font-medium text-gray-900">{telegram}</p>
          </div>
        </a>
      </div>
    </div>
  );
}
