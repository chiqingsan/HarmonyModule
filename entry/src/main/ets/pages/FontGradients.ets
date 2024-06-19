@Entry
@Component
struct FontGradients {
  @State message: string = 'Hello World';
  @State textX: string = "-20%"

  build() {
    Row() {
      Column() {
        Row() {
          Text(this.message)
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
            .blendMode(BlendMode.DST_IN, BlendApplyType.OFFSCREEN)
            .width("200%")
            .textAlign(TextAlign.Center)
            .offset({
              x: this.textX
            })
            .onAppear(() => {
              animateTo({ duration: 5000, curve: Curve.Linear, iterations: -1 }, () => {
                // this.textX = "20%"
              })
            })
        }
        .width("100%")
        .linearGradient({
          direction: GradientDirection.Right,
          colors: [[0xff0000, 0.0], [0x0000ff, 0.3], [0xffff00, 1.0]]
        })
        .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
      }
      .width('100%')
    }
    .height('100%')
  }
}