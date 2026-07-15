/**
 * 数据库管理 - 使用关系型数据库 (SQLite)
 */
import relationalStore from '@ohos.data.relationalStore';

const DB_NAME = 'kidney_care.db';

let rdbStore: relationalStore.RdbStore | null = null;

export async function getRdbStore(): Promise<relationalStore.RdbStore> {
  if (rdbStore) {
    return rdbStore;
  }

  const config: relationalStore.StoreConfig = {
    name: DB_NAME,
    securityLevel: relationalStore.SecurityLevel.S1
  };

  rdbStore = await relationalStore.getRdbStore(globalThis.context, config);

  const sqls: string[] = [
    'CREATE TABLE IF NOT EXISTS blood_pressure (id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp INTEGER NOT NULL, systolic INTEGER NOT NULL, diastolic INTEGER NOT NULL, pulse INTEGER DEFAULT 0, create_time INTEGER NOT NULL)',
    'CREATE TABLE IF NOT EXISTS weight_record (id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp INTEGER NOT NULL, weight REAL NOT NULL, create_time INTEGER NOT NULL)',
    'CREATE TABLE IF NOT EXISTS lab_test (id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp INTEGER NOT NULL, test_type TEXT NOT NULL, items TEXT NOT NULL, create_time INTEGER NOT NULL)'
  ];

  for (let i = 0; i < sqls.length; i++) {
    await rdbStore.executeSql(sqls[i]);
  }

  return rdbStore;
}

// 血压记录

export async function insertBpRecord(record: any): Promise<number> {
  const store = await getRdbStore();
  const row = {
    timestamp: record.timestamp,
    systolic: record.systolic,
    diastolic: record.diastolic,
    pulse: record.pulse || 0,
    create_time: Date.now()
  };
  return store.insert('blood_pressure', row);
}

export async function getBpRecords(): Promise<any[]> {
  const store = await getRdbStore();
  const result = await store.querySql('SELECT * FROM blood_pressure ORDER BY timestamp DESC');
  const records: any[] = [];
  while (result.goToNextRow()) {
    records.push({
      id: result.getLong(result.getColumnIndex('id')),
      timestamp: result.getLong(result.getColumnIndex('timestamp')),
      systolic: result.getLong(result.getColumnIndex('systolic')),
      diastolic: result.getLong(result.getColumnIndex('diastolic')),
      pulse: result.getLong(result.getColumnIndex('pulse'))
    });
  }
  result.close();
  return records;
}

export async function getTodayBpRecords(): Promise<any[]> {
  const all: any[] = await getBpRecords();
  const startOfDay: number = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate()).getTime();
  const endOfDay: number = startOfDay + 24 * 60 * 60 * 1000;
  const result: any[] = [];
  for (let i = 0; i < all.length; i++) {
    if (all[i].timestamp >= startOfDay && all[i].timestamp < endOfDay) {
      result.push(all[i]);
    }
  }
  return result;
}

export async function getLatestBpRecord(): Promise<any> {
  const records: any[] = await getBpRecords();
  return records.length > 0 ? records[0] : null;
}

// 体重记录

export async function insertWeightRecord(record: any): Promise<number> {
  const store = await getRdbStore();
  const row = {
    timestamp: record.timestamp,
    weight: record.weight,
    create_time: Date.now()
  };
  return store.insert('weight_record', row);
}

export async function getWeightRecords(limit: number): Promise<any[]> {
  const store = await getRdbStore();
  const result = await store.querySql('SELECT * FROM weight_record ORDER BY timestamp DESC LIMIT ?', [limit]);
  const records: any[] = [];
  while (result.goToNextRow()) {
    records.push({
      id: result.getLong(result.getColumnIndex('id')),
      timestamp: result.getLong(result.getColumnIndex('timestamp')),
      weight: result.getDouble(result.getColumnIndex('weight'))
    });
  }
  result.close();
  return records;
}

export async function getLatestWeight(): Promise<any> {
  const records: any[] = await getWeightRecords(1);
  return records.length > 0 ? records[0] : null;
}

// 化验记录

export async function insertLabTest(record: any): Promise<number> {
  const store = await getRdbStore();
  const row = {
    timestamp: record.timestamp,
    test_type: record.testType,
    items: JSON.stringify(record.items),
    create_time: Date.now()
  };
  return store.insert('lab_test', row);
}

export async function getLabTests(limit: number): Promise<any[]> {
  const store = await getRdbStore();
  const result = await store.querySql('SELECT * FROM lab_test ORDER BY timestamp DESC LIMIT ?', [limit]);
  const records: any[] = [];
  while (result.goToNextRow()) {
    const itemsStr: string = result.getString(result.getColumnIndex('items'));
    let items: any[] = [];
    try {
      items = JSON.parse(itemsStr);
    } catch (e) {
      items = [];
    }
    records.push({
      id: result.getLong(result.getColumnIndex('id')),
      timestamp: result.getLong(result.getColumnIndex('timestamp')),
      testType: result.getString(result.getColumnIndex('test_type')),
      items: items
    });
  }
  result.close();
  return records;
}

export async function getLatestLabTest(): Promise<any> {
  const records: any[] = await getLabTests(1);
  return records.length > 0 ? records[0] : null;
}
