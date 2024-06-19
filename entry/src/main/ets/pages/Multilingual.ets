import I18n from '@ohos.i18n';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Multilingual {
  @State message: string = 'Hello World';

  toggleChinese() {
    try {
      I18n.System.setAppPreferredLanguage("zh-Hans"); // 设置应用偏好语言为zh-Hans
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`call System.setAppPreferredLanguage failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  toggleToEnglish() {
    try {
      I18n.System.setAppPreferredLanguage("en-US"); // 设置应用偏好语言为en-US
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`call System.setAppPreferredLanguage failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  build() {
    Column({ space: 30 }) {
      Button("中文")
        .onClick(() => {
          this.toggleChinese()
        })
      Button("英文")
        .onClick(() => {
          this.toggleToEnglish()
        })
      Text($r("app.string.test_text"))
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}