import { webview } from '@kit.ArkWeb'
import { picker } from '@kit.CoreFileKit'

class WebSdk {
  async openAlbum() {
    const album = new picker.PhotoViewPicker()
    const res = await album.select({
      maxSelectNumber: 1,
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE
    })
    if (res.photoUris.length) {
      // AlertDialog.show({ message: JSON.stringify(res.photoUris, null, 2) })
      return res

    }
    return null
  }

  alert(str: string) {
    AlertDialog.show({ message: JSON.stringify(str, null, 2) })
  }
}


@Entry
@Component
struct HybridCalls {
  webController: webview.WebviewController = new webview.WebviewController()
  webSdk: WebSdk = new WebSdk()

  async openAlbum() {
    const album = new picker.PhotoViewPicker()
    const res = await album.select({
      maxSelectNumber: 1,
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE
    })
    if (res.photoUris.length) {
      this.webController.runJavaScript(`setImage('${res.photoUris[0]}')`)
      // this.webController.runJavaScript(`openAlbum()`)
      // AlertDialog.show({ message: JSON.stringify(res.photoUris, null, 2) })
    }
  }

  build() {
    Column() {
      Button("原生端打开相册")
        .margin(30)
        .onClick(() => {
          this.openAlbum()
        })
      Web({
        src: $rawfile("indexCalls.html"),
        controller: this.webController
      })
        .layoutWeight(1)
        .margin(10)
        .border({
          width: 1,
          color: "#2c2c2c",
          radius: 10
        })/*
           * 需要传入4个参数
           * name jsBridge在网页中的全局变量名称 可以随便起
           * methodList: 提供给web端可以调用的方法名列表
           * controlle: web绑定的控制器
           * object: sdk工具集实例
           */
        .javaScriptProxy({
          name: "Calls",
          methodList: ["openAlbum", "alert"],
          controller: this.webController,
          object: this.webSdk
        })

    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}

