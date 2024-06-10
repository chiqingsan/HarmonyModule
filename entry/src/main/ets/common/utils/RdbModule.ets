import { relationalStore, ValuesBucket } from '@kit.ArkData'

// 数据库名和表名
const tableName = 'chiqingsan'
// 创建数据库的语句
const sqlCreate = `CREATE TABLE IF NOT EXISTS ${tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date_added INTEGER NOT NULL
      )`


// RdbModule类用于封装对关系型数据库的操作
/*传入表名,建表语句,和安全级别来实例化一个关系型数据库*/
class RdbModule {
  // 操作数据库的实例
  private store: relationalStore.RdbStore | null = null;
  private tableName: string; // 数据库表的名称
  private sqlCreate: string; // 创建数据库表的SQL语句
  private securityLevel: relationalStore.SecurityLevel; // 数据库的安全等级

  // 构造函数，初始化表名、创建语句和安全等级
  constructor(tableName: string, sqlCreate: string, securityLevel: relationalStore.SecurityLevel) {
    if (sqlCreate.includes(tableName)) {
      this.tableName = tableName;
      this.sqlCreate = sqlCreate;
      this.securityLevel = securityLevel;
    } else {
      // 如果表名和建表语句内的表名不匹配,则抛出错误
      console.error("The table name does not match the statement that created the table")
      throw new Error("The table name does not match the statement that created the table");
    }
  }

  // 获取数据库操作实例，如果已存在则直接返回，否则创建新的实例
  async getStoreInstance() {
    if (this.store) {
      return this.store;
    }
    const store = await relationalStore.getRdbStore(getContext(), {
      name: this.tableName + '.db', // 数据库名称
      securityLevel: this.securityLevel // 安全等级
    });
    store.executeSql(this.sqlCreate); // 执行创建表的SQL语句
    this.store = store; // 存储实例以便后续使用
    return this.store; // 返回数据库操作实例
  }

  // 插入一条数据到数据库
  async setData<T extends ValuesBucket>(value: T) {
    const store = await this.getStoreInstance();
    return store.insert(this.tableName, value);
  }

  // 查询数据库中的数据量
  async getTotal() {
    const store = await this.getStoreInstance();
    const predicates = new relationalStore.RdbPredicates(this.tableName);
    const results = await store.query(predicates);
    return results.rowCount <= 0 ? 0 : results.rowCount;
  }

  // 查询数据库列表，可以指定单个或多个ID，返回一个数组
  async getTheList<T>(id?: number | number[]) {
    const store = await this.getStoreInstance();
    const predicates = new relationalStore.RdbPredicates(this.tableName);
    if (typeof id === 'number') {
      id = [id];
    }
    id !== undefined ? predicates.in("id", id) : predicates.orderByDesc("id");
    const results = await store.query(predicates);

    const list: T[] = [];
    while (results.goToNextRow()) {
      list.push(results.getRow() as T);
    }
    return list;
  }

  // 更新数据库中的数据
  async upData<T extends ValuesBucket>(id: number, val: T) {
    const store = await this.getStoreInstance();
    const predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo("id", id);
    return store.update(val, predicates);
  }

  // 删除数据库中的数据
  async delData(id: number) {
    const store = await this.getStoreInstance();
    const predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo("id", id);
    return store.delete(predicates);
  }
}

// 创建RdbModule实例，并传入表名、创建语句和安全等级
// 如果需要多个数据库，可以导出多个实例
export const rdbModule = new RdbModule(tableName, sqlCreate, relationalStore.SecurityLevel.S1);
