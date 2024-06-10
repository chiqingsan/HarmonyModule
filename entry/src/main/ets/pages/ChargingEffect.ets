@Entry
@Component
struct ChargingEffect {
  @State electricity: number = 0;
  @State timer: number = -1

  aboutToAppear(): void {

  }

  build() {
    Column() {
      Row() {
        Progress({
          value: this.electricity,
          total: 100
        }).layoutWeight(1)
        Text(this.timer === -1 ? "待充电" : "充电中...")
      }.width("100%")

      Button(this.timer === -1 ? "开始充电" : "停止充电")
        .backgroundColor(this.timer === -1 ? null : "#f00")
        .onClick(() => {
          if (this.timer !== -1) {
            clearInterval(this.timer)
            this.timer = -1
          } else {
            this.timer = setInterval(() => {
              this.electricity += 1
              if (this.electricity >= 100) {
                this.electricity = 0
              }
            }, 100)

          }
        })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}