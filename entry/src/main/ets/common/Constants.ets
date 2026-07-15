/**
 * 慢性肾病健康管理 - 常量与类型定义
 * 包含血检、尿检的关键指标定义
 */

// 类型定义
export interface TestItem {
  key: string;
  name: string;
  unit: string;
  type: 'number' | 'select';
  options?: string[];
  normalRange: string;
  placeholder: string;
}

export interface TestRecordItem {
  key: string;
  name: string;
  unit: string;
  value: string;
  type: 'number' | 'select';
}

export interface LabTestRecord {
  id?: number;
  timestamp: number;
  testType: 'blood' | 'urine';
  items: TestRecordItem[];
  createTime?: number;
}

export interface BpRecord {
  id?: number;
  timestamp: number;
  systolic: number;
  diastolic: number;
  pulse: number;
  createTime?: number;
}

export interface WeightRecord {
  id?: number;
  timestamp: number;
  weight: number;
  createTime?: number;
}

// 血检指标定义
export const BLOOD_TEST_ITEMS: TestItem[] = [
  {
    key: 'creatinine',
    name: '血肌酐 (Cr)',
    unit: 'μmol/L',
    type: 'number',
    normalRange: '44~106',
    placeholder: '请输入数值'
  },
  {
    key: 'bun',
    name: '尿素氮 (BUN)',
    unit: 'mmol/L',
    type: 'number',
    normalRange: '2.5~7.1',
    placeholder: '请输入数值'
  },
  {
    key: 'egfr',
    name: 'eGFR',
    unit: 'mL/min/1.73m²',
    type: 'number',
    normalRange: '≥90',
    placeholder: '请输入数值'
  },
  {
    key: 'uric_acid',
    name: '尿酸 (UA)',
    unit: 'μmol/L',
    type: 'number',
    normalRange: '150~440',
    placeholder: '请输入数值'
  },
  {
    key: 'hemoglobin',
    name: '血红蛋白 (Hb)',
    unit: 'g/L',
    type: 'number',
    normalRange: '115~175',
    placeholder: '请输入数值'
  },
  {
    key: 'potassium',
    name: '血钾 (K⁺)',
    unit: 'mmol/L',
    type: 'number',
    normalRange: '3.5~5.5',
    placeholder: '请输入数值'
  },
  {
    key: 'phosphorus',
    name: '血磷 (P)',
    unit: 'mmol/L',
    type: 'number',
    normalRange: '0.85~1.45',
    placeholder: '请输入数值'
  },
  {
    key: 'calcium',
    name: '血钙 (Ca²⁺)',
    unit: 'mmol/L',
    type: 'number',
    normalRange: '2.1~2.6',
    placeholder: '请输入数值'
  },
  {
    key: 'pth',
    name: '甲状旁腺激素 (PTH)',
    unit: 'pg/mL',
    type: 'number',
    normalRange: '10~65',
    placeholder: '请输入数值'
  },
  {
    key: 'albumin',
    name: '白蛋白 (ALB)',
    unit: 'g/L',
    type: 'number',
    normalRange: '35~55',
    placeholder: '请输入数值'
  }
];

// 尿检指标定义
export const URINE_TEST_ITEMS: TestItem[] = [
  {
    key: 'urine_protein',
    name: '尿蛋白 (Pro)',
    unit: '',
    type: 'select',
    options: ['- (阴性)', '+', '++', '+++'],
    normalRange: '- (阴性)',
    placeholder: '请选择'
  },
  {
    key: 'urine_occult_blood',
    name: '尿潜血 (BLD)',
    unit: '',
    type: 'select',
    options: ['- (阴性)', '+', '++', '+++'],
    normalRange: '- (阴性)',
    placeholder: '请选择'
  },
  {
    key: 'urine_glucose',
    name: '尿糖 (GLU)',
    unit: '',
    type: 'select',
    options: ['- (阴性)', '+', '++', '+++'],
    normalRange: '- (阴性)',
    placeholder: '请选择'
  },
  {
    key: 'urine_ketone',
    name: '尿酮体 (KET)',
    unit: '',
    type: 'select',
    options: ['- (阴性)', '+', '++', '+++'],
    normalRange: '- (阴性)',
    placeholder: '请选择'
  },
  {
    key: 'acr',
    name: 'ACR (微量白蛋白/肌酐)',
    unit: 'mg/g',
    type: 'number',
    normalRange: '<30',
    placeholder: '请输入数值'
  },
  {
    key: 'urine_ph',
    name: '尿 pH 值',
    unit: '',
    type: 'number',
    normalRange: '4.5~8.0',
    placeholder: '请输入数值'
  },
  {
    key: 'urine_sg',
    name: '尿比重 (SG)',
    unit: '',
    type: 'number',
    normalRange: '1.003~1.030',
    placeholder: '请输入数值'
  },
  {
    key: 'urine_protein_24h',
    name: '24h 尿蛋白定量',
    unit: 'mg/24h',
    type: 'number',
    normalRange: '<150',
    placeholder: '请输入数值'
  }
];

// 血压正常范围
export const BP_NORMAL = {
  systolic: { min: 90, max: 130 },
  diastolic: { min: 60, max: 85 }
};

// UI 颜色
export const COLORS = {
  primary: '#4A90D9',
  primaryLight: '#E8F0FE',
  warning: '#E8573A',
  warningLight: '#FDE8E3',
  normal: '#4CAF50',
  normalLight: '#E8F5E9',
  textPrimary: '#1A1A2E',
  textSecondary: '#8E8EA0',
  textHint: '#B0B0C0',
  cardBg: '#FFFFFF',
  pageBg: '#F7F8FC',
  divider: '#E8E8EE'
};

// 日期格式工具
export function formatDate(timestamp: number): string {
  const d = new Date(timestamp);
  const y = d.getFullYear();
  const m = (d.getMonth() + 1).toString().padStart(2, '0');
  const day = d.getDate().toString().padStart(2, '0');
  return `${y}年${m}月${day}日`;
}

export function formatTime(timestamp: number): string {
  const d = new Date(timestamp);
  const h = d.getHours().toString().padStart(2, '0');
  const m = d.getMinutes().toString().padStart(2, '0');
  return `${h}:${m}`;
}

export function formatDateTime(timestamp: number): string {
  return formatDate(timestamp) + ' ' + formatTime(timestamp);
}
