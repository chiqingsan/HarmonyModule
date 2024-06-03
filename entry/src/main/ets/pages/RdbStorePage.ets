import { relationalStore, ValuesBucket } from '@kit.ArkData';
import { rdbModule } from '../common/utils/RdbModule';

interface NoteItem extends ValuesBucket {
  id: number | null
  title: string
  content: string
  date_added: number | string
}


@Entry
@Component
struct RdbStorePage {
  val: string = ""
  tableName: string = "chiqingsan"
  createATable: string = `CREATE TABLE IF NOT EXISTS ${this.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date_added INTEGER NOT NULL
      )`
  private store: relationalStore.RdbStore | null = null

  async createADatabase() {
    if (this.store) {
      return this.store
    }
    this.store = await relationalStore.getRdbStore(getContext(), {
      name: "chiqingsan.db",
      securityLevel: relationalStore.SecurityLevel.S1
    })

    this.store.executeSql(this.createATable)

    return this.store
  }

  // 获取数据库管理对象
  async getStoreInstance() {
    // 如果已经存在，直接返回
    if (this.store) {
      return this.store
    }
    // 获取操作数据库的管理对象(如果数据库文件不存在，会自动创建数据库文件)
    this.store = await relationalStore.getRdbStore(getContext(), {
      name: 'heima.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
    })
    // 执行创建表的语句 execute 执行
    this.store.executeSql(this.createATable)
    // 返回 store 对象
    return this.store
  }

  build() {

  }
}

