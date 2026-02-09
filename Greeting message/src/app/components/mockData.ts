// Моковые данные для демонстрации платформы

export interface Student {
  id: string;
  name: string;
  class: string;
  avatar?: string;
}

export interface Grade {
  subject: string;
  grades: number[];
  average: number;
}

export interface Schedule {
  day: string;
  lessons: {
    time: string;
    subject: string;
    teacher: string;
    room: string;
  }[];
}

export interface Contact {
  name: string;
  role: string;
  phone: string;
  whatsapp: string;
  telegram: string;
  subject?: string;
}

export interface Teacher {
  id: string;
  name: string;
  subject: string;
  avatar?: string;
}

export interface ClassGroup {
  id: string;
  name: string;
  students: Student[];
}

// Данные для родителей
export const mockChildren: Student[] = [
  { id: '1', name: 'Алексей Иванов', class: '8А' },
  { id: '2', name: 'Мария Иванова', class: '6Б' },
];

export const mockGradesForChild = (childId: string): Grade[] => {
  if (childId === '1') {
    return [
      { subject: 'Математика', grades: [5, 4, 5, 5, 4], average: 4.6 },
      { subject: 'Русский язык', grades: [4, 4, 5, 4], average: 4.25 },
      { subject: 'Физика', grades: [5, 5, 5, 4], average: 4.75 },
      { subject: 'Английский язык', grades: [4, 5, 4, 5], average: 4.5 },
      { subject: 'История', grades: [5, 4, 4, 5], average: 4.5 },
      { subject: 'Информатика', grades: [5, 5, 5, 5], average: 5.0 },
    ];
  } else {
    return [
      { subject: 'Математика', grades: [5, 5, 4, 5], average: 4.75 },
      { subject: 'Русский язык', grades: [5, 4, 5, 5], average: 4.75 },
      { subject: 'Биология', grades: [4, 4, 5, 4], average: 4.25 },
      { subject: 'Английский язык', grades: [5, 5, 5, 4], average: 4.75 },
      { subject: 'География', grades: [4, 5, 4, 4], average: 4.25 },
    ];
  }
};

export const mockScheduleForChild = (childId: string): Schedule[] => {
  if (childId === '1') {
    return [
      {
        day: 'Понедельник',
        lessons: [
          { time: '08:00 - 08:45', subject: 'Математика', teacher: 'Смирнова А.В.', room: '201' },
          { time: '09:00 - 09:45', subject: 'Русский язык', teacher: 'Петров И.С.', room: '105' },
          { time: '10:00 - 10:45', subject: 'Физика', teacher: 'Кузнецова М.П.', room: '304' },
          { time: '11:00 - 11:45', subject: 'Английский язык', teacher: 'Соколова Е.А.', room: '210' },
        ],
      },
      {
        day: 'Вторник',
        lessons: [
          { time: '08:00 - 08:45', subject: 'История', teacher: 'Николаев В.И.', room: '108' },
          { time: '09:00 - 09:45', subject: 'Информатика', teacher: 'Федоров Д.М.', room: '401' },
          { time: '10:00 - 10:45', subject: 'Математика', teacher: 'Смирнова А.В.', room: '201' },
          { time: '11:00 - 11:45', subject: 'Физика', teacher: 'Кузнецова М.П.', room: '304' },
        ],
      },
    ];
  } else {
    return [
      {
        day: 'Понедельник',
        lessons: [
          { time: '08:00 - 08:45', subject: 'Математика', teacher: 'Смирнова А.В.', room: '201' },
          { time: '09:00 - 09:45', subject: 'Русский язык', teacher: 'Петров И.С.', room: '105' },
          { time: '10:00 - 10:45', subject: 'Биология', teacher: 'Морозова Т.В.', room: '203' },
          { time: '11:00 - 11:45', subject: 'Английский язык', teacher: 'Соколова Е.А.', room: '210' },
        ],
      },
      {
        day: 'Вторник',
        lessons: [
          { time: '08:00 - 08:45', subject: 'География', teacher: 'Волков С.Н.', room: '107' },
          { time: '09:00 - 09:45', subject: 'Математика', teacher: 'Смирнова А.В.', room: '201' },
          { time: '10:00 - 10:45', subject: 'Русский язык', teacher: 'Петров И.С.', room: '105' },
          { time: '11:00 - 11:45', subject: 'Английский язык', teacher: 'Соколова Е.А.', room: '210' },
        ],
      },
    ];
  }
};

export const mockTeachersForParent: Contact[] = [
  {
    name: 'Смирнова Анна Викторовна',
    role: 'Преподаватель',
    subject: 'Математика',
    phone: '+7 (999) 123-45-67',
    whatsapp: '+79991234567',
    telegram: '@smirnova_av',
  },
  {
    name: 'Петров Иван Сергеевич',
    role: 'Преподаватель',
    subject: 'Русский язык',
    phone: '+7 (999) 234-56-78',
    whatsapp: '+79992345678',
    telegram: '@petrov_is',
  },
  {
    name: 'Кузнецова Мария Павловна',
    role: 'Преподаватель',
    subject: 'Физика',
    phone: '+7 (999) 345-67-89',
    whatsapp: '+79993456789',
    telegram: '@kuznetsova_mp',
  },
  {
    name: 'Соколова Елена Андреевна',
    role: 'Преподаватель',
    subject: 'Английский язык',
    phone: '+7 (999) 456-78-90',
    whatsapp: '+79994567890',
    telegram: '@sokolova_ea',
  },
];

// Данные для преподавателей
export const mockClassGroups: ClassGroup[] = [
  {
    id: '8a',
    name: '8А',
    students: [
      { id: '1', name: 'Алексей Иванов', class: '8А' },
      { id: '3', name: 'Петр Сидоров', class: '8А' },
      { id: '4', name: 'Ольга Николаева', class: '8А' },
      { id: '5', name: 'Дмитрий Козлов', class: '8А' },
    ],
  },
  {
    id: '8b',
    name: '8Б',
    students: [
      { id: '6', name: 'Екатерина Морозова', class: '8Б' },
      { id: '7', name: 'Андрей Волков', class: '8Б' },
      { id: '8', name: 'Анна Федорова', class: '8Б' },
    ],
  },
];

export const mockStudentGrades = (studentId: string): { [subject: string]: number[] } => {
  const grades: { [key: string]: { [subject: string]: number[] } } = {
    '1': { 'Математика': [5, 4, 5, 5, 4] },
    '3': { 'Математика': [4, 4, 4, 3, 4] },
    '4': { 'Математика': [5, 5, 4, 5, 5] },
    '5': { 'Математика': [3, 4, 3, 4, 3] },
    '6': { 'Математика': [5, 5, 5, 5, 4] },
    '7': { 'Математика': [4, 3, 4, 4, 3] },
    '8': { 'Математика': [5, 4, 5, 4, 5] },
  };
  return grades[studentId] || { 'Математика': [] };
};

export const mockTeacherSchedule: Schedule[] = [
  {
    day: 'Понедельник',
    lessons: [
      { time: '08:00 - 08:45', subject: 'Математика', teacher: '8А', room: '201' },
      { time: '09:00 - 09:45', subject: 'Математика', teacher: '6Б', room: '201' },
      { time: '10:00 - 10:45', subject: 'Математика', teacher: '8Б', room: '201' },
    ],
  },
  {
    day: 'Вторник',
    lessons: [
      { time: '09:00 - 09:45', subject: 'Математика', teacher: '6А', room: '201' },
      { time: '10:00 - 10:45', subject: 'Математика', teacher: '8А', room: '201' },
      { time: '11:00 - 11:45', subject: 'Математика', teacher: '8Б', room: '201' },
    ],
  },
  {
    day: 'Среда',
    lessons: [
      { time: '08:00 - 08:45', subject: 'Математика', teacher: '8А', room: '201' },
      { time: '09:00 - 09:45', subject: 'Математика', teacher: '6Б', room: '201' },
    ],
  },
];

export const mockParentsContacts: Contact[] = [
  {
    name: 'Иванов Сергей Петрович',
    role: 'Родитель',
    phone: '+7 (999) 111-22-33',
    whatsapp: '+79991112233',
    telegram: '@ivanov_sp',
  },
  {
    name: 'Сидорова Татьяна Ивановна',
    role: 'Родитель',
    phone: '+7 (999) 222-33-44',
    whatsapp: '+79992223344',
    telegram: '@sidorova_ti',
  },
  {
    name: 'Николаев Александр Дмитриевич',
    role: 'Родитель',
    phone: '+7 (999) 333-44-55',
    whatsapp: '+79993334455',
    telegram: '@nikolaev_ad',
  },
];

// Данные для учеников
export const mockStudentInfo = {
  name: 'Алексей Иванов',
  class: '8А',
  id: '1',
};

export const mockStudentGradesData: Grade[] = [
  { subject: 'Математика', grades: [5, 4, 5, 5, 4], average: 4.6 },
  { subject: 'Русский язык', grades: [4, 4, 5, 4], average: 4.25 },
  { subject: 'Физика', grades: [5, 5, 5, 4], average: 4.75 },
  { subject: 'Английский язык', grades: [4, 5, 4, 5], average: 4.5 },
  { subject: 'История', grades: [5, 4, 4, 5], average: 4.5 },
  { subject: 'Информатика', grades: [5, 5, 5, 5], average: 5.0 },
];

export const mockStudentSchedule: Schedule[] = [
  {
    day: 'Понедельник',
    lessons: [
      { time: '08:00 - 08:45', subject: 'Математика', teacher: 'Смирнова А.В.', room: '201' },
      { time: '09:00 - 09:45', subject: 'Русский язык', teacher: 'Петров И.С.', room: '105' },
      { time: '10:00 - 10:45', subject: 'Физика', teacher: 'Кузнецова М.П.', room: '304' },
      { time: '11:00 - 11:45', subject: 'Английский язык', teacher: 'Соколова Е.А.', room: '210' },
    ],
  },
  {
    day: 'Вторник',
    lessons: [
      { time: '08:00 - 08:45', subject: 'История', teacher: 'Николаев В.И.', room: '108' },
      { time: '09:00 - 09:45', subject: 'Информатика', teacher: 'Федоров Д.М.', room: '401' },
      { time: '10:00 - 10:45', subject: 'Математика', teacher: 'Смирнова А.В.', room: '201' },
      { time: '11:00 - 11:45', subject: 'Физика', teacher: 'Кузнецова М.П.', room: '304' },
    ],
  },
  {
    day: 'Среда',
    lessons: [
      { time: '08:00 - 08:45', subject: 'Математика', teacher: 'Смирнова А.В.', room: '201' },
      { time: '09:00 - 09:45', subject: 'Английский язык', teacher: 'Соколова Е.А.', room: '210' },
      { time: '10:00 - 10:45', subject: 'История', teacher: 'Николаев В.И.', room: '108' },
    ],
  },
];

export const mockTeachersForStudent: Contact[] = mockTeachersForParent;
