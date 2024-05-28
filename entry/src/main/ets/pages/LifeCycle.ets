@Entry
@Component
struct LifeCycle {
  @State message: string = 'Hello World';
  @State show: boolean = true

  aboutToAppear(): void {
    console.log("LifeCycle_aboutToAppear:", JSON.stringify("页面开始准备展示"))
  }

  aboutToDisappear(): void {
    console.log("LifeCycle_aboutToDisappear:", JSON.stringify("页面开始准备销毁"))
  }

  onPageShow(): void {
    console.log("LifeCycle_onPageShow:", JSON.stringify("页面进入了前台"))
  }

  onPageHide(): void {
    console.log("LifeCycle_onPageHide:", JSON.stringify("页面进入了后台"))
  }

  onBackPress(): boolean | void {
    console.log("LifeCycle_onBackPress:", JSON.stringify("用户返回了"))
  }

  build() {
    Column() {
      Button("展示组件")
        .onClick(() => {
          this.show = !this.show
        })
      if (this.show) {
        MyText({ message: this.message + Date.now() })
      }
    }.width("100%").height("100%").justifyContent(FlexAlign.Center)
  }
}


@Reusable
@Component
struct MyText {
  @State message: string = 'chiqingsan'

  aboutToAppear(): void {
    console.log("LifeCycle_aboutToAppear:", "子组件开始准备展示")
  }

  aboutToDisappear(): void {
    console.log("LifeCycle_aboutToDisappear:", "子组件开始准备销毁")
  }

  aboutToReuse(params: Record<string, ESObject>) {
    console.log("LifeCycle_aboutToReuse:", "组件准备挂载到组件树")
    console.log("LifeCycle_params:", JSON.stringify(params))
    this.message = params.message
  }

  aboutToRecycle(): void {
    console.log("LifeCycle_aboutToRecycle:", "组件即将进入复用缓存")
  }

  build() {
    Column() {
      Text(this.message)
        .fontSize(20)
    }
    .borderWidth(2)
    .height(100)
    .justifyContent(FlexAlign.Center)
  }
}