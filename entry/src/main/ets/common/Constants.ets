/**
 * 慢性肾病健康管理 - 常量与类型
 */

// 血检指标定义
export interface TestItem {
  key: string;
  name: string;
  unit: string;
  type: string;
  options?: string[];
  normalRange: string;
  placeholder: string;
}

export const BLOOD_TEST_ITEMS: TestItem[] = [
  { key: 'creatinine', name: '血肌酐 (Cr)', unit: 'μmol/L', type: 'number', normalRange: '44~106', placeholder: '请输入数值' },
  { key: 'bun', name: '尿素氮 (BUN)', unit: 'mmol/L', type: 'number', normalRange: '2.5~7.1', placeholder: '请输入数值' },
  { key: 'egfr', name: 'eGFR', unit: 'mL/min·1.73m²', type: 'number', normalRange: '≥90', placeholder: '请输入数值' },
  { key: 'uric_acid', name: '尿酸 (UA)', unit: 'μmol/L', type: 'number', normalRange: '150~440', placeholder: '请输入数值' },
  { key: 'hemoglobin', name: '血红蛋白 (Hb)', unit: 'g/L', type: 'number', normalRange: '115~175', placeholder: '请输入数值' },
  { key: 'potassium', name: '血钾 (K⁺)', unit: 'mmol/L', type: 'number', normalRange: '3.5~5.5', placeholder: '请输入数值' },
  { key: 'phosphorus', name: '血磷 (P)', unit: 'mmol/L', type: 'number', normalRange: '0.85~1.45', placeholder: '请输入数值' },
  { key: 'calcium', name: '血钙 (Ca²⁺)', unit: 'mmol/L', type: 'number', normalRange: '2.1~2.6', placeholder: '请输入数值' },
  { key: 'pth', name: '甲状旁腺激素 (PTH)', unit: 'pg/mL', type: 'number', normalRange: '10~65', placeholder: '请输入数值' },
  { key: 'albumin', name: '白蛋白 (ALB)', unit: 'g/L', type: 'number', normalRange: '35~55', placeholder: '请输入数值' }
];

export const URINE_TEST_ITEMS: TestItem[] = [
  { key: 'urine_protein', name: '尿蛋白 (Pro)', unit: '', type: 'select', options: ['- (阴性)', '+', '++', '+++'], normalRange: '- (阴性)', placeholder: '请选择' },
  { key: 'urine_occult_blood', name: '尿潜血 (BLD)', unit: '', type: 'select', options: ['- (阴性)', '+', '++', '+++'], normalRange: '- (阴性)', placeholder: '请选择' },
  { key: 'urine_glucose', name: '尿糖 (GLU)', unit: '', type: 'select', options: ['- (阴性)', '+', '++', '+++'], normalRange: '- (阴性)', placeholder: '请选择' },
  { key: 'urine_ketone', name: '尿酮体 (KET)', unit: '', type: 'select', options: ['- (阴性)', '+', '++', '+++'], normalRange: '- (阴性)', placeholder: '请选择' },
  { key: 'acr', name: 'ACR (微量白蛋白/肌酐)', unit: 'mg/g', type: 'number', normalRange: '<30', placeholder: '请输入数值' },
  { key: 'urine_ph', name: '尿 pH 值', unit: '', type: 'number', normalRange: '4.5~8.0', placeholder: '请输入数值' },
  { key: 'urine_sg', name: '尿比重 (SG)', unit: '', type: 'number', normalRange: '1.003~1.030', placeholder: '请输入数值' },
  { key: 'urine_protein_24h', name: '24h 尿蛋白定量', unit: 'mg/24h', type: 'number', normalRange: '<150', placeholder: '请输入数值' }
];

export const BP_NORMAL_SYS: number = 130;
export const BP_NORMAL_DIA: number = 85;

export const COLOR_PRIMARY: string = '#4A90D9';
export const COLOR_WARNING: string = '#E8573A';
export const COLOR_NORMAL: string = '#4CAF50';
export const COLOR_TEXT_PRIMARY: string = '#1A1A2E';
export const COLOR_TEXT_SECONDARY: string = '#8E8EA0';
export const COLOR_TEXT_HINT: string = '#B0B0C0';
export const COLOR_CARD: string = '#FFFFFF';
export const COLOR_PAGE: string = '#F7F8FC';
export const COLOR_DIVIDER: string = '#E8E8EE';

export function formatDate(timestamp: number): string {
  const d: Date = new Date(timestamp);
  return d.getFullYear() + '年' + (d.getMonth() + 1) + '月' + d.getDate() + '日';
}

export function formatTime(timestamp: number): string {
  const d: Date = new Date(timestamp);
  const h: string = d.getHours() < 10 ? '0' + d.getHours() : '' + d.getHours();
  const m: string = d.getMinutes() < 10 ? '0' + d.getMinutes() : '' + d.getMinutes();
  return h + ':' + m;
}

export function formatDateTime(timestamp: number): string {
  return formatDate(timestamp) + ' ' + formatTime(timestamp);
}

export function todayString(): string {
  const d: Date = new Date();
  const y: number = d.getFullYear();
  const m: string = d.getMonth() + 1 < 10 ? '0' + (d.getMonth() + 1) : '' + (d.getMonth() + 1);
  const day: string = d.getDate() < 10 ? '0' + d.getDate() : '' + d.getDate();
  return y + '-' + m + '-' + day;
}
