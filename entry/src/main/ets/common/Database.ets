/**
 * 数据库管理 - 使用关系型数据库 (SQLite)
 */
import relationalStore from '@ohos.data.relationalStore';
import { BpRecord, WeightRecord, LabTestRecord, TestRecordItem } from './Constants';

const DB_NAME = 'kidney_care.db';
const TABLE_BP = 'blood_pressure';
const TABLE_WEIGHT = 'weight_record';
const TABLE_LAB = 'lab_test';

let rdbStore: relationalStore.RdbStore | null = null;

// 获取数据库实例
export async function getRdbStore(): Promise<relationalStore.RdbStore> {
  if (rdbStore) {
    return rdbStore;
  }

  const config: relationalStore.StoreConfig = {
    name: DB_NAME,
    securityLevel: relationalStore.SecurityLevel.S1
  };

  rdbStore = await relationalStore.getRdbStore(globalThis.context, config);
  await initTables(rdbStore);
  return rdbStore;
}

// 初始化表结构
async function initTables(store: relationalStore.RdbStore): Promise<void> {
  const sqls = [
    `CREATE TABLE IF NOT EXISTS ${TABLE_BP} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      timestamp INTEGER NOT NULL,
      systolic INTEGER NOT NULL,
      diastolic INTEGER NOT NULL,
      pulse INTEGER DEFAULT 0,
      create_time INTEGER NOT NULL
    )`,
    `CREATE TABLE IF NOT EXISTS ${TABLE_WEIGHT} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      timestamp INTEGER NOT NULL,
      weight REAL NOT NULL,
      create_time INTEGER NOT NULL
    )`,
    `CREATE TABLE IF NOT EXISTS ${TABLE_LAB} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      timestamp INTEGER NOT NULL,
      test_type TEXT NOT NULL,
      items TEXT NOT NULL,
      create_time INTEGER NOT NULL
    )`
  ];

  for (const sql of sqls) {
    await store.executeSql(sql);
  }
}

// ===== 血压记录 =====

export async function insertBpRecord(record: BpRecord): Promise<number> {
  const store = await getRdbStore();
  const now = Date.now();
  const row = {
    timestamp: record.timestamp,
    systolic: record.systolic,
    diastolic: record.diastolic,
    pulse: record.pulse || 0,
    create_time: now
  };
  const rowId = await store.insert(TABLE_BP, row);
  return rowId;
}

export async function getBpRecords(dateStart?: number, dateEnd?: number): Promise<BpRecord[]> {
  const store = await getRdbStore();
  let where = '';
  let args: number[] = [];
  if (dateStart && dateEnd) {
    where = 'WHERE timestamp >= ? AND timestamp <= ?';
    args = [dateStart, dateEnd];
  }
  const sql = `SELECT * FROM ${TABLE_BP} ${where} ORDER BY timestamp DESC`;
  const result = await store.querySql(sql, args);
  const records: BpRecord[] = [];
  while (result.goToNextRow()) {
    records.push({
      id: result.getLong(result.getColumnIndex('id')),
      timestamp: result.getLong(result.getColumnIndex('timestamp')),
      systolic: result.getLong(result.getColumnIndex('systolic')),
      diastolic: result.getLong(result.getColumnIndex('diastolic')),
      pulse: result.getLong(result.getColumnIndex('pulse')),
      createTime: result.getLong(result.getColumnIndex('create_time'))
    });
  }
  result.close();
  return records;
}

export async function getLatestBpRecord(): Promise<BpRecord | null> {
  const store = await getRdbStore();
  const sql = `SELECT * FROM ${TABLE_BP} ORDER BY timestamp DESC LIMIT 1`;
  const result = await store.querySql(sql);
  if (result.goToFirstRow()) {
    const record: BpRecord = {
      id: result.getLong(result.getColumnIndex('id')),
      timestamp: result.getLong(result.getColumnIndex('timestamp')),
      systolic: result.getLong(result.getColumnIndex('systolic')),
      diastolic: result.getLong(result.getColumnIndex('diastolic')),
      pulse: result.getLong(result.getColumnIndex('pulse')),
      createTime: result.getLong(result.getColumnIndex('create_time'))
    };
    result.close();
    return record;
  }
  result.close();
  return null;
}

export async function getTodayBpRecords(): Promise<BpRecord[]> {
  const now = new Date();
  const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate()).getTime();
  const endOfDay = startOfDay + 24 * 60 * 60 * 1000;
  return getBpRecords(startOfDay, endOfDay);
}

// ===== 体重记录 =====

export async function insertWeightRecord(record: WeightRecord): Promise<number> {
  const store = await getRdbStore();
  const now = Date.now();
  const row = {
    timestamp: record.timestamp,
    weight: record.weight,
    create_time: now
  };
  return store.insert(TABLE_WEIGHT, row);
}

export async function getWeightRecords(limit: number = 30): Promise<WeightRecord[]> {
  const store = await getRdbStore();
  const sql = `SELECT * FROM ${TABLE_WEIGHT} ORDER BY timestamp DESC LIMIT ?`;
  const result = await store.querySql(sql, [limit]);
  const records: WeightRecord[] = [];
  while (result.goToNextRow()) {
    records.push({
      id: result.getLong(result.getColumnIndex('id')),
      timestamp: result.getLong(result.getColumnIndex('timestamp')),
      weight: result.getDouble(result.getColumnIndex('weight')),
      createTime: result.getLong(result.getColumnIndex('create_time'))
    });
  }
  result.close();
  return records;
}

export async function getLatestWeight(): Promise<WeightRecord | null> {
  const store = await getRdbStore();
  const sql = `SELECT * FROM ${TABLE_WEIGHT} ORDER BY timestamp DESC LIMIT 1`;
  const result = await store.querySql(sql);
  if (result.goToFirstRow()) {
    const record: WeightRecord = {
      id: result.getLong(result.getColumnIndex('id')),
      timestamp: result.getLong(result.getColumnIndex('timestamp')),
      weight: result.getDouble(result.getColumnIndex('weight')),
      createTime: result.getLong(result.getColumnIndex('create_time'))
    };
    result.close();
    return record;
  }
  result.close();
  return null;
}

// ===== 化验记录 =====

export async function insertLabTest(record: LabTestRecord): Promise<number> {
  const store = await getRdbStore();
  const now = Date.now();
  const row = {
    timestamp: record.timestamp,
    test_type: record.testType,
    items: JSON.stringify(record.items),
    create_time: now
  };
  return store.insert(TABLE_LAB, row);
}

export async function getLabTests(limit: number = 20): Promise<LabTestRecord[]> {
  const store = await getRdbStore();
  const sql = `SELECT * FROM ${TABLE_LAB} ORDER BY timestamp DESC LIMIT ?`;
  const result = await store.querySql(sql, [limit]);
  const records: LabTestRecord[] = [];
  while (result.goToNextRow()) {
    records.push({
      id: result.getLong(result.getColumnIndex('id')),
      timestamp: result.getLong(result.getColumnIndex('timestamp')),
      testType: result.getString(result.getColumnIndex('test_type')) as 'blood' | 'urine',
      items: JSON.parse(result.getString(result.getColumnIndex('items'))),
      createTime: result.getLong(result.getColumnIndex('create_time'))
    });
  }
  result.close();
  return records;
}

export async function getLatestLabTest(): Promise<LabTestRecord | null> {
  const store = await getRdbStore();
  const sql = `SELECT * FROM ${TABLE_LAB} ORDER BY timestamp DESC LIMIT 1`;
  const result = await store.querySql(sql);
  if (result.goToFirstRow()) {
    const record: LabTestRecord = {
      id: result.getLong(result.getColumnIndex('id')),
      timestamp: result.getLong(result.getColumnIndex('timestamp')),
      testType: result.getString(result.getColumnIndex('test_type')) as 'blood' | 'urine',
      items: JSON.parse(result.getString(result.getColumnIndex('items'))),
      createTime: result.getLong(result.getColumnIndex('create_time'))
    };
    result.close();
    return record;
  }
  result.close();
  return null;
}
