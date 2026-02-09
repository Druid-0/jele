import { ReactNode } from 'react';

interface MobileFrameProps {
  children: ReactNode;
}

export function MobileFrame({ children }: MobileFrameProps) {
  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center p-4">
      <div className="w-full max-w-[400px] h-[800px] bg-white rounded-[32px] shadow-2xl overflow-hidden border-8 border-gray-800 relative">
        {/* Notch */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-32 h-6 bg-gray-800 rounded-b-2xl z-50" />
        
        {/* Screen Content */}
        <div className="h-full overflow-hidden">
          {children}
        </div>
      </div>
    </div>
  );
}
