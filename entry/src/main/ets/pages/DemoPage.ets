@Entry
@Component
struct Demo11_login {
  @State xs: number = 12
  @State sm: number = 8
  @State md: number = 8
  @State lg: number = 12

  build() {
    Stack() {
      // 辅助用的栅格（顶层粉色区域）
      GridRow({
        gutter: 10,
        columns: {
          xs: this.xs,
          sm: this.sm,
          md: this.md,
          lg: this.lg
        }
      }) {
        ForEach(Array.from({ length: 12 }), () => {
          GridCol()
            .width('100%')
            .height('100%')
            .backgroundColor('#67ffafbd')
        })
      }
      .zIndex(2)
      .height('100%')

      //  内容区域
      GridRow({
        gutter: 10,
        // TODO 分别设置不同断点的 列数
        columns: {
          xs: this.xs,
          sm: this.sm,
          md: this.md,
          lg: this.lg
        }

      }) {
        // 列
        GridCol({
          // TODO 分别设置不同断点的 所占列数

          span: {
            xs: 10,
            sm: 6,
            md: 4,
            lg: 6
          },
          // TODO 分别设置不同断点的 偏移

          offset: {
            xs: 1,
            sm: 1,
            md: 2,
            lg: 3
          }
        }) {
          Column() {
            // logo+文字
            LogoCom()

            // 输入框 + 底部提示文本
            InputCom()

            // 登录+注册账号按钮
            ButtonCom()

          }
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#ebf0f2')
    }
  }
}

@Component
struct LogoCom {
  build() {
    Column({ space: 5 }) {
      Image($r('app.media.ic_logo'))
        .width(80)
      Text('登录界面')
        .fontSize(23)
        .fontWeight(900)
      Text('登录账号以使用更多服务')
        .fontColor(Color.Gray)
    }
    .margin({ top: 100 })
  }
}

@Component
struct InputCom {
  build() {
    Column() {
      Column() {
        TextInput({ placeholder: '账号' })
          .backgroundColor(Color.Transparent)
        Divider()
          .color(Color.Gray)
        TextInput({ placeholder: '密码' })
          .type(InputType.Password)
          .backgroundColor(Color.Transparent)

      }
      .backgroundColor(Color.White)
      .borderRadius(20)
      .padding({ top: 10, bottom: 10 })

      Row() {
        Text('短信验证码登录')
          .fontColor('#006af7')
          .fontSize(14)
        Text('忘记密码')
          .fontColor('#006af7')
          .fontSize(14)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 10 })

    }
    .padding(5)
    .margin({ top: 80 })

  }
}

@Component
struct ButtonCom {
  build() {
    Column({ space: 10 }) {
      Button('登录')
        .width('90%')
      Text('注册账号')
        .fontColor('#006af7')
        .fontSize(16)
    }
    .margin({ top: 60 })
  }
}