import { preferences } from '@kit.ArkData'


class PreferencesManager {
  // 需要保存到磁盘的文件名称
  private pname: string

  constructor(pname: string) {
    this.pname = pname
  }

  // 泛型继承, 规定传入的数据类型. 保存数据方法, 负责保存数据到首选项
  // 规定类型为 number | string | boolean | Array<number> | Array<string> | Array<boolean> | Uint8Array;
  async saveData<T extends preferences.ValueType>(key: string, value: T) {
    const pre = preferences.getPreferencesSync(getContext(), { name: this.pname })
    pre.putSync(key, value)
    // 把内存中的数据写入磁盘,完成持久化
    await pre.flush()
  }

  // 获取数据
  // 注意, 此处使用读取数据的同步方法, 没有使用flush写入磁盘, 所以不需要加async, 加上async后会导致方法异步执行
  getData<T extends preferences.ValueType>(key: string, defaultValue: T) {
    const pre = preferences.getPreferencesSync(getContext(), { name: this.pname })
    return pre.getSync(key, defaultValue) as T
  }

  // 删除数据
  async delAllData(key: string) {
    const pre = preferences.getPreferencesSync(getContext(), { name: this.pname })
    pre.deleteSync(key)
    await pre.flush()
  }
}

// 实例化后导出, MyPreferences和Store可自行按需求命名
export const MyPreferences = new PreferencesManager("Store")