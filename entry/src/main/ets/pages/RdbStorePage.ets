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
    Column({ space: 12 }) {
      TextInput()
        .margin(20)
        .onChange((val) => {
          this.val = val
        })
      Button("创建数据库")
        .onClick(async () => {
          rdbModule.getStoreInstance()
        })
      Button("删除数据库")
        .onClick(() => {
          relationalStore.deleteRdbStore(getContext(), "chiqingsan.db")
        })
        .backgroundColor(Color.Red)
        .enabled(false)

      Button("插入数据库文件")
        .onClick(async () => {
          const res = await rdbModule.insert<NoteItem>({
            id: null,
            title: `今天天气好_${this.val}`,
            content: '想吃肯德基',
            date_added: Date.now()
          })

          AlertDialog.show({ message: `添加成功,id:${res}` })

        })
      Button("删除数据库数据")
        .onClick(async () => {

          const delNum = rdbModule.deleteData(1)
          AlertDialog.show({ message: `一共删除了${delNum}行数据` })
        })
        .backgroundColor(Color.Red)
      Button("更新数据库数据")
        .onClick(async () => {

          const modifyNum = await rdbModule.update(1, {
            title: "改了标题"
          } as NoteItem)
          AlertDialog.show({ message: `一共修改了${modifyNum}行数据` })

        })
      Button("查询数据库数据字段")
        .onClick(async () => {
          const store = await this.createADatabase()
          const predicate = new relationalStore.RdbPredicates(this.tableName)
          const res = await store?.query(predicate)
          AlertDialog.show({ message: `当前表的字段数:${res.columnNames},当前表一共有${res.rowCount}条数据` })
        })
      Button("查询数据库数据")
        .onClick(async () => {
          const list = await rdbModule.queryTheList<NoteItem>()
          AlertDialog.show({ message: JSON.stringify(list, null, 2) })
        })
    }.height("100%").width("100%").justifyContent(FlexAlign.Center)
  }
}

