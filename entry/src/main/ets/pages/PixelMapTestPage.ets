import image from '@ohos.multimedia.image';
import { drawing } from '@kit.ArkGraphics2D';

@Entry
@Component
struct PixelMapTestPage {
  @State message: string = "PixelMap";
  @State currentColor: string = "#ffffff"
  @State pixelMap: image.PixelMap = image.createPixelMapSync(new ArrayBuffer(200 * 200 * 4), {
    editable: true,
    size: {
      height: 200,
      width: 200
    }
  })

  aboutToAppear(): void {
    if (canIUse("SystemCapability.Graphics.Drawing")) {
      const canvas = new drawing.Canvas(this.pixelMap);
      const brush = new drawing.Brush();
      const gradient =
        drawing.ShaderEffect.createLinearGradient({ x: 0, y: 0 }, { x: 200, y: 200 },
          [0xFFFF00FF, 0xFFFFFF00, 0xFF00FFFF, 0xFFEE00CC],
          drawing.TileMode.REPEAT)
      brush.setShaderEffect(gradient)
      canvas.attachBrush(brush)
      canvas.drawRect(0, 0, 200, 200)
    }
  }

  readPixels(pixelMap: image.PixelMap, x: number, y: number) {
    const pixelInformation = new ArrayBuffer(4)
    const area: image.PositionArea = {
      pixels: pixelInformation,
      offset: 0,
      stride: 4,
      region: { size: { height: 1, width: 1 }, x, y }
    };
    pixelMap.readPixelsSync(area);
    // 创建 Uint8Array 视图
    const uint8Array = new Uint8Array(pixelInformation);

    // 每个像素有4个字节（BGRA）
    const b = uint8Array[0].toString(16).padStart(2, '0')
    const g = uint8Array[1].toString(16).padStart(2, '0')
    const r = uint8Array[2].toString(16).padStart(2, '0')

    return `#${r}${g}${b}`
  }

  build() {
    Column({ space: 12 }) {
      Text(this.message)
        .fontSize(50)
        .fontWeight(600)
      Image(this.pixelMap)
        .width(200)
        .height(200)
        .onTouch((event) => {
          this.currentColor = this.readPixels(this.pixelMap, event.touches[0].x, event.touches[0].y)
        })
      Text()
        .width(100)
        .height(50)
        .backgroundColor(this.currentColor)
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}