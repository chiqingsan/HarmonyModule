import { Animator as animator, AnimatorOptions, AnimatorResult } from '@kit.ArkUI';

@Entry
@Component
struct AnimationTestPage {
  @State message: string = 'Hello World';
  @State config: AnimatorOptions[] = []

  build() {
    Scroll() {
      Column({ space: 12 }) {
        Button("添加一个动画模块")
          .onClick(() => {
            const config: AnimatorOptions = {
              duration: 2000,
              easing: "linear",
              delay: 0,
              fill: "forwards",
              direction: "normal",
              iterations: -1,
              begin: 0,
              end: 0
            }
            this.config.push(config)
          })
        ForEach(this.config, (config: AnimatorOptions, index) => {
          TextView({
            config: config,
            callback: () => {
              this.config.splice(index, 1)
            }
          })
            .width("100%")
        })
        // .backgroundColor(Color.Orange)
      }
      .constraintSize({ minWidth: "100%", minHeight: "100%" })
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
    .width('100%')
  }
}


/** 文字节目 */
@Component
export struct TextView {
  // 传递过来的文本素材对象
  @State @Watch("updateAnimations") config: AnimatorOptions = {
    duration: 2000,
    easing: "linear",
    delay: 0,
    fill: "forwards",
    direction: "normal",
    iterations: -1,
    begin: 0,
    end: 0
  }
  // 偏移度,控制动画
  @State offx: number = 0
  // 主窗口的宽度
  @State mainWidth: number = 0
  @State isStop: boolean = false
  backAnimator: AnimatorResult | undefined = undefined
  callback: () => void = () => {
  }

  aboutToAppear(): void {

    // AlertDialog.show({ message: JSON.stringify(this.item, null, 2) })
    this.create()
    this.backAnimator!.play()

    console.log("aboutToAppear")

  }

  aboutToDisappear() {
    this.backAnimator?.cancel()
    this.backAnimator = undefined;
  }

  create() {
    this.backAnimator = animator.create(this.config)
    this.backAnimator.onFinish = () => {
      console.info('backAnimator onfinish')
      this.backAnimator?.play()
    }
    this.backAnimator.onRepeat = () => {
      // console.info('backAnimator repeat')
    }
    this.backAnimator.onCancel = () => {
      this.offx = 0
      console.info('backAnimator cancel')
    }
    this.backAnimator.onFrame = (value: number) => {
      this.offx = value
    }
  }

  updateAnimations() {
    console.log("updateAnimations")
    // 更新动画配置
    this.backAnimator?.reset(this.config)
    // setTimeout(() => {
    //   this.backAnimator?.reset(this.config)
    // })
    // this.backAnimator?.play()
  }

  build() {
    Column({ space: 12 }) {
      Row({ space: 12 }) {
        Button(this.isStop ? "播放" : "暂停")
          .padding({ left: 25, right: 25 })
          .onClick(() => {
            if (this.isStop) {
              this.backAnimator?.play()
              this.isStop = false
            } else {
              this.backAnimator?.pause()
              this.isStop = true
            }
          })
        Button("停止")
          .padding({ left: 25, right: 25 })
          .onClick(() => {
            this.backAnimator?.cancel()
          })
        Button("反向")
          .padding({ left: 25, right: 25 })
          .onClick(() => {
            this.backAnimator?.reverse()
          })
        Button("删除组件")
          .onClick(() => {
            this.callback()
          })
      }.width("100%")

      Row() {
        Row() {
          Text()
            .width(100)
            .aspectRatio(1)
            .backgroundColor(Color.Orange)
            .translate({ x: this.offx })
        }
        .width("100%")
        .height(100)
        .blendMode(BlendMode.DST_ATOP, BlendApplyType.OFFSCREEN)
        .onAreaChange((ov, nv) => {
          this.mainWidth = nv.width as number

          this.config.begin = -100
          this.config.end = nv.width as number
        })

      }
      // .justifyContent(this.isStop ? FlexAlign.Center : FlexAlign.Start)
      .linearGradient({
        angle: 50,
        colors: [
          ["#ffff0900", 0.0],
          ["#ffffcc00", 0.2],
          ["#ff1aff00", 0.4],
          ["#ff00ffcc", 0.5],
          ["#ff0037ff", 0.6],
          ["#ffcc00ff", 0.8],
          ["#ffff0011", 1],]
      })

      .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
    }

  }
}