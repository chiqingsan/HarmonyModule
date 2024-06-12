@Entry
@Component
struct ChargingEffect {
  @State @Watch("calculateTheTime") electricity: number = 0;
  timer: number = -1
  // 记录是否在充电
  @State isCharging: boolean = false
  @State chargingSpeed: number = 300
  @State voltage: string = "4"

  // 开始充电
  startCharging() {
    if (this.isCharging) {
      clearInterval(this.timer)
      this.isCharging = false
    } else {
      this.isCharging = true
      this.timer = setInterval(() => {
        this.electricity += 1
        this.voltage = (Math.random() - 0.7 + 4).toFixed(2)
        if (this.electricity >= 100) {
          this.electricity = 0
          this.voltage = '4'
        }
      }, this.chargingSpeed)

    }
  }

  // 重置进度
  resetYourProgress() {
    clearInterval(this.timer)
    this.isCharging = false
    this.electricity = 0
  }

  // 时间计算函数
  calculateTheTime() {
    const remainingPower = 100 - this.electricity
    return remainingPower * this.chargingSpeed / 1000
  }

  build() {
    Column({ space: 20 }) {

      Text(`距离充满预计还有：${this.calculateTheTime()}s`)
        .width("100%")
        .padding({ left: 20, right: 20 })
      Row({ space: 12 }) {
        Progress({
          value: this.electricity,
          total: 100
        })
          .layoutWeight(1)
          .style({
            strokeWidth: 16
          })
        Text(`${this.electricity}%`)
        Text(this.isCharging ? "充电中..." : "待充电")
      }
      .width("100%")
      .padding({ left: 20, right: 20 })

      Row({ space: 30 }) {
        Button(this.isCharging ? "停止充电" : "开始充电")
          .backgroundColor(this.isCharging ? "#f00" : null)
          .onClick(() => {
            this.startCharging()
          })
        Button("重置进度")
          .onClick(() => {
            this.resetYourProgress()
          })
      }

      // 充电信息
      Column({ space: 5 }) {
        Text(`当前连接充电器的类型：${"未获取"}`)
        Text(`当前设备充电的电压：${this.isCharging ? this.voltage + "伏" : "未获取"}`)
        Text(`当前设备电池的型号：${"Li-ion"}`)
        Text(`当前设备电池的温度：${25}℃`)
      }
      .width("100%")
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 20, right: 20 })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}