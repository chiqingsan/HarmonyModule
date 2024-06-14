import { router } from '@kit.ArkUI'

interface pageJump {
  title: string
  path: string
}


@Entry
@Component
struct Index {
  @State text: string = "Index 页面跳转目录"
  myPage: pageJump[] = [
    { title: "图片上传", path: "/pages/FileUpload".slice(1) },
    { title: "关系型数据库", path: "/pages/RdbStorePage".slice(1) },
    { title: "卡片", path: "/pages/CircularList".slice(1) },
    { title: "DemoPage", path: "/pages/DemoPage".slice(1) },
    { title: "充电动画", path: "/pages/ChargingEffect".slice(1) },
    { title: "Web混合开发", path: "/pages/HybridWeb".slice(1) },
    { title: "Web混合调用", path: "/pages/HybridCalls".slice(1) },
  ]

  build() {
    Column({ space: 20 }) {
      Text(this.text)
        .fontSize(30)
        .fontWeight(600)
      List({ space: 20 }) {
        ForEach(
          this.myPage.reverse(),
          (item: pageJump) => {
            ListItem() {
              this.myRow(item.title, item.path)
            }
          }
        )
      }
      .scrollBar(BarState.Off)
      .padding({ bottom: 50 })

    }.padding(20)
  }

  @Builder
  myRow(text: string, path: string) {
    Row() {
      Text(`跳转到 ${text} 页面`)
        .fontSize(26)
        .margin({ left: 20 })
        .textAlign(TextAlign.Center)
    }
    .onClick(() => {
      router.pushUrl({ url: path })
    })
    .myRowStyle()
  }
}

@Extend(Row)
function myRowStyle() {
  .width("100%")
  .height(60)
  .backgroundColor("#ffffe6e8")
  .shadow({
    radius: 5,
    color: "#ddd"
  })
  .borderRadius(10)
  .padding(10)
}

