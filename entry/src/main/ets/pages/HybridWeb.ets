import { webview } from '@kit.ArkWeb'

interface eventMessages {
  type: string
  message: string
}

@Entry
@Component
struct HybridWeb {
  webController: webview.WebviewController = new webview.WebviewController()
  // 声明一个端口数据,用来保存创建出来的端口
  currentPorts: webview.WebMessagePort[] = []

  sendMessage() {
    const message: eventMessages = {
      type: "change",
      message: `Ark ${Date.now()}`
    }
    this.currentPorts[0].postMessageEvent(JSON.stringify(message))
  }

  // 创建端口
  createPorts() {
    // 返回webview.WebMessagePort[],里面有两个端口
    try {
      this.currentPorts = this.webController.createWebMessagePorts()
      if (this.currentPorts.length) {
        // postMessage需要3个参数, 1.要发送的消息名称(标识) 2.端口(这里把第二个端口发送过去) 3.web组件的uri,*代表通配
        this.webController.postMessage("trans_port", [this.currentPorts[1]], "*")
        // 使用剩下的端口来注册监听回传的消息
        this.currentPorts[0].onMessageEvent((event: webview.WebMessage) => {
          if (typeof event === "string") {
            AlertDialog.show({ message: event })
            // JSON.parse(event) as eventMessages
          }
        })
      }
    } catch (e) {
      console.error("createPorts: ", JSON.stringify(e))
    }
  }

  build() {
    Column() {
      Button("向Web发送消息")
        .margin(30)
        .onClick(() => {
          this.sendMessage()
        })
      Web({
        src: $rawfile("index.html"),
        controller: this.webController
      })
        .layoutWeight(1)
        .margin(10)
        .border({
          width: 1,
          color: "#2c2c2c",
          radius: 10
        })
        .domStorageAccess(true)
        .onPageEnd(() => {
          this.createPorts()
        })
        .onAlert((event) => {
          AlertDialog.show({ message: JSON.stringify(event?.message, null, 2) })
          return true
        })

    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}