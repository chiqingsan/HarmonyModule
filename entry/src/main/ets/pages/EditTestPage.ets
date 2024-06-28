// todo 需要完成一个组件拖拽的工具类


// 添加节目的数据结构
interface programsListModel {
  id: string,
  type: "text" | "image" | "video",
  text?: string,
  imgPath?: ResourceStr,
  videoPath?: ResourceStr,
}

// xy坐标接口
interface coordinate {
  x: number
  y: number
}

// 矩形区域接口
interface rectangularArea extends coordinate {
  width: number
  height: number
}

// 点击位置的枚举
enum clickPositionEnum {
  TopRight = 'topRight',
  BottomRight = 'bottomRight',
  BottomLeft = 'bottomLeft',
  TopLeft = 'topLeft',
  Top = 'top',
  Right = 'right',
  Bottom = 'bottom',
  Left = 'left',
}

// 计算是否点击边框或者四角
function checkClickPosition(rectangle: rectangularArea, borderSize: number, clickPosition: coordinate) {
  // 定义矩形区域的位置和尺寸
  const left = rectangle.x; // 矩形的左边界
  const top = rectangle.y; // 矩形的上边界
  const right = rectangle.x + rectangle.width; // 矩形的右边界
  const bottom = rectangle.y + rectangle.height; // 矩形的下边界
  const cornerSize = rectangle.width / 5; // 边角的尺寸，边框大小的一半

  // 定义边框的位置
  // Log.info(rectangle, "rectangle")
  // Log.info(clickPosition, "clickPosition")
  // 这里使用了日志函数来记录矩形和点击位置，这有助于调试和日志记录。

  // 检查点击位置是否在边框上
  // 首先检查点击位置是否在右上角
  if (clickPosition.x >= right - cornerSize && clickPosition.x <= right + borderSize &&
    clickPosition.y >= top - borderSize &&
    clickPosition.y <= top + cornerSize) {
    // 如果点击位置在右上角，返回对应的方向
    return clickPositionEnum.TopRight;
  } else
  // 接着检查点击位置是否在右下角
  if (clickPosition.x >= right - cornerSize && clickPosition.x <= right + borderSize &&
    clickPosition.y >= bottom - cornerSize && clickPosition.y <= bottom + borderSize) {
    // 如果点击位置在右下角，返回对应的方向
    return clickPositionEnum.BottomRight;
  } else
  // 然后检查点击位置是否在左下角
  if (clickPosition.x >= left - borderSize && clickPosition.x <= left + cornerSize &&
    clickPosition.y >= bottom - cornerSize &&
    clickPosition.y <= bottom + borderSize) {
    // 如果点击位置在左下角，返回对应的方向
    return clickPositionEnum.BottomLeft;
  } else
  // 最后检查点击位置是否在左上角
  if (clickPosition.x >= left - borderSize && clickPosition.x <= left + cornerSize &&
    clickPosition.y >= top - borderSize &&
    clickPosition.y <= top + cornerSize) {
    // 如果点击位置在左上角，返回对应的方向
    return clickPositionEnum.TopLeft;
  } else
  // 接下来检查点击位置是否在顶部
  if (clickPosition.x >= left && clickPosition.x <= right && clickPosition.y >= top - borderSize &&
    clickPosition.y <= top + borderSize) {
    // 如果点击位置在顶部，返回对应的方向
    return clickPositionEnum.Top;
  } else
  // 然后检查点击位置是否在右侧
  if (clickPosition.x >= right - borderSize && clickPosition.x <= right + borderSize && clickPosition.y >= top &&
    clickPosition.y <= bottom) {
    // 如果点击位置在右侧，返回对应的方向
    return clickPositionEnum.Right;
  } else
  // 接着检查点击位置是否在底部
  if (clickPosition.x >= left && clickPosition.x <= right && clickPosition.y >= bottom - borderSize &&
    clickPosition.y <= bottom + borderSize) {
    // 如果点击位置在底部，返回对应的方向
    return clickPositionEnum.Bottom;
  } else
  // 然后检查点击位置是否在左侧
  if (clickPosition.x >= left - borderSize && clickPosition.x <= left + borderSize && clickPosition.y >= top &&
    clickPosition.y <= bottom) {
    // 如果点击位置在左侧，返回对应的方向
    return clickPositionEnum.Left;
  } else {
    // 如果点击位置不在边框上，返回false
    // 这意味着点击位置在组件内部，没有触发边框或四角的逻辑
    return false;
  }
}

// 可活动的容器组件
@Entry
@Component
struct EditTestPage {
  // 节目列表
  @State programsList: programsListModel[] = []
  @State mainWindowX: number = 0
  @State mainWindowY: number = 0
  @State offsetX: number = 0
  @State offsetY: number = 0
  // 主要缩放
  @State mainScale: number = 1
  // 活动缩放
  @State activeScale: number = 1
  @State ComponentWidth: number = 0
  @State ComponentHeight: number = 0

  build() {
    Column() {
      Row({ space: 15 }) {
        Button("添加文字")
          .onClick(() => {
            this.programsList.push({
              id: Date.now().toString() + Math.floor(Math.random() * 10000),
              type: "text",
              text: "默认的一段文字"
            })
          })

        Button("添加图片")
          .onClick(() => {
            this.programsList.push({
              id: Date.now().toString() + Math.floor(Math.random() * 10000),
              type: "image",
              imgPath: $r("app.media.ic_logo")
            })
          })
        Button("添加视频")
          .onClick(() => {
            // this.programsList.push({
            //   id:Date.now().toString()+Math.floor(Math.random()*10000),
            //   type:"video",
            // })
          })
      }
      .width("100%")
      .padding(20)
      .justifyContent(FlexAlign.SpaceBetween)

      Column() {
        Stack() {
          ForEach(this.programsList, (item: programsListModel, index) => {
            viewContainers({
              parentComponentWidth: this.ComponentWidth,
              parentComponentHeight: this.ComponentHeight
            }) {
              if (item.type === "text") {
                Text(item?.text)
                  .id(item.id)
                  .maxLines(1)
              } else if (item.type === "image") {
                Image(item?.imgPath)
                  .id(item.id)
                  .width(150)
                  .height(150)

              } else if (item.type === "video") {
                Video({
                  src: item?.videoPath
                })
                  .id(item.id)
                  .constraintSize({
                    maxWidth: "100%",
                    maxHeight: "100%"
                  })
              }
            }
          })
        }
        .width(`60%`)
        .height(`60%`)
        .borderRadius(10)
        .onAreaChange((oldV, newV) => {
          this.ComponentWidth = Number(newV.width)
          this.ComponentHeight = Number(newV.height)
        })
        .offset({
          x: this.mainWindowX + this.offsetX,
          y: this.mainWindowY + this.offsetY
        })
        .scale({
          x: this.mainScale * this.activeScale < .2 ? .2 : this.mainScale * this.activeScale,
          y: this.mainScale * this.activeScale < .2 ? .2 : this.mainScale * this.activeScale
        })
        .backgroundColor("#888")
      }
      .height("100%")
      .width("100%")
      .backgroundColor("#ddd")
      .clip(true)
      .justifyContent(FlexAlign.Center)
      .gesture(
        // 拖动手势
        PanGesture()
          .onActionUpdate((event: GestureEvent) => {
            if (event) {
              console.log("EditTestPage_event:", JSON.stringify(event))
              this.offsetX = event.offsetX
              this.offsetY = event.offsetY
            }
          })
          .onActionEnd((event) => {
            if (event) {
              // 保存基数据,重置活动数据
              this.mainWindowX += this.offsetX
              this.mainWindowY += this.offsetY
              this.offsetX = 0
              this.offsetY = 0
            }
          })
      )
      .priorityGesture(
        // 捏合手势
        PinchGesture()
          .onActionUpdate((event: GestureEvent) => {
            if (event) {
              console.log("EditTestPage_event:", JSON.stringify(event))
              this.activeScale = event.scale
            }
          })
          .onActionEnd((event) => {
            if (event) {
              // 保存基数据,重置活动数据
              this.mainScale = this.mainScale * this.activeScale < .2 ? .2 : this.mainScale * this.activeScale
              this.activeScale = 1
            }
          })
      )
    }
    .height('100%')
    .width('100%')
  }
}


@Component
struct viewContainers {
  // 是否展示边框
  @Prop isBorderShow: boolean = false
  // 外部插槽,外部传递的UI
  @BuilderParam ShowContents: () => void = this.Show
  // 当前位置的XY,定位容器的位置
  @State mainWindowX: number = 0
  @State mainWindowY: number = 0
  // 偏移度XY,用来移动容器
  @State offsetX: number = 0
  @State offsetY: number = 0
  // 父组件的宽高,由外部传递进来
  parentComponentWidth: number = 0
  parentComponentHeight: number = 0
  // 当前组件的宽高,初始值为null
  @State currentComponentWidth: number | null = null
  @State currentComponentHeight: number | null = null
  // 是否正在按压
  @State isPress: boolean = false
  // 是否调整大小
  @State isDrag: boolean = false
  // 按压方向
  pressDirection: false | string = false
  // 原宽高
  @State originalWidth: number = 0
  @State originalHeight: number = 0
  // 活动坐标
  @State activeX: number = 0
  @State activeY: number = 0
  // 是否固定组件位置
  @State isFixedX: boolean = false
  @State isFixedY: boolean = false
  // 边框的宽度
  @State borderW: number = 3

  // 区域限制,计算X值
  regionalRestrictionsX() {
    if (this.mainWindowX + this.offsetX < 0) {
      return 0
    } else if (this.mainWindowX + this.offsetX > this.parentComponentWidth - this.currentComponentWidth!) {
      return this.parentComponentWidth - this.currentComponentWidth!
    } else {
      return this.mainWindowX + this.offsetX
    }
  }

  // 区域限制,计算Y值
  regionalRestrictionsY() {
    if (this.mainWindowY + this.offsetY < 0) {
      return 0
    } else if (this.mainWindowY + this.offsetY > this.parentComponentHeight - this.currentComponentHeight!) {
      return this.parentComponentHeight - this.currentComponentHeight!
    } else {
      return this.mainWindowY + this.offsetY
    }
  }

  // 默认插槽内容
  @Builder
  Show() {
  }

  build() {
    Stack() {
      // 插入的内容
      this.ShowContents()

      if (this.isPress) {
        Stack() {
          Column() {
            Divider()
              .strokeWidth(1)
            Divider()
              .strokeWidth(1)
          }
          .height("100%")
          .width("100%")
          .justifyContent(FlexAlign.SpaceEvenly)

          Row() {
            Divider()
              .strokeWidth(1)
              .vertical(true)
            Divider()
              .strokeWidth(1)
              .vertical(true)
          }
          .height("100%")
          .width("100%")
          .justifyContent(FlexAlign.SpaceEvenly)
        }.layoutWeight(1)
      }
    }
    // 自定义触摸热区
    .responseRegion([
      {
        x: "-8%",
        y: "-8%",
        width: "116%",
        height: "116%"
      }
    ])
    // 初始的宽高度
    .width(this.currentComponentWidth ?? "60%")
    .height(this.currentComponentHeight ?? "60%")

    // 开始事件独占响应
    .monopolizeEvents(true)
    .onAreaChange((oldV, newV) => {
      // Log.info(oldV, "oldV")
      // 把初始化的宽高记录下来
      if (this.currentComponentWidth === null && this.currentComponentHeight === null) {
        this.currentComponentWidth = Number(newV.width)
        this.currentComponentHeight = Number(newV.height)
      }
    })
    .position({
      x: this.isFixedX ? this.activeX : this.regionalRestrictionsX(),
      y: this.isFixedY ? this.activeY : this.regionalRestrictionsY()
    })
    .border({
      width: this.borderW,
      color: Color.Red
    })
    .gesture(
      // 拖动手势
      PanGesture()
        .onActionUpdate((event) => {
          // 如果正在拖拽边框,则屏蔽拖动手势
          if (!this.isDrag) {
            this.offsetX = event.offsetX
            this.offsetY = event.offsetY
          }
        })
        .onActionEnd(() => {
          // 如果正在拖拽边框,则屏蔽拖动手势
          if (!this.isDrag) {
            // 保存基数据,重置活动数据
            this.mainWindowX = this.regionalRestrictionsX()
            this.mainWindowY = this.regionalRestrictionsY()
            this.offsetX = 0
            this.offsetY = 0
          }
        })
    )
    .onTouch((event) => {
      // 手指按压触发
      if (event.type === TouchType.Down) {
        // 按压的时候.显示辅助线
        this.isPress = true
        // 按下的时候检查按压的地方是内容还是边框
        const rectangular: rectangularArea = {
          x: 0,
          y: 0,
          width: Number(event.target.area.width),
          height: Number(event.target.area.height)
        }
        const clickCoordinates: coordinate = {
          x: event.touches[0].x,
          y: event.touches[0].y
        }

        // 检测点击的位置
        this.pressDirection = checkClickPosition(rectangular, 8, clickCoordinates)

        // 处理触摸开始事件，记录初始触摸位置和盒子原始大小
        this.originalWidth = Number(event.target.area.width)
        this.originalHeight = Number(event.target.area.height)
      }
      // 抬起触发
      if (event.type === TouchType.Up) {
        // 重置是否按压状态
        this.isPress = false
        // 重置是否在拖拽边框状态
        this.isDrag = false
        // 重置点击的位置
        this.pressDirection = false

        // 处理固定定位改变的变量,把改变的变量赋值给基数据
        this.mainWindowX = this.isFixedX ? this.activeX : this.mainWindowX
        this.mainWindowY = this.isFixedY ? this.activeY : this.mainWindowY
        // 重置是否固定位置
        this.isFixedX = false
        this.isFixedY = false

      }
      // 移动触发
      if (event.type === TouchType.Move) {
        // promptAction.showToast({ message: JSON.stringify(checkClickPosition(rectangular, 5, clickCoordinates)) })
        // 判断是否点击在边框上
        if (this.pressDirection) {
          // 如果点击在边框上,这屏蔽拖动手势
          this.isDrag = true
          // 判断拖动方向,处理相应的逻辑
          // 根据触摸方向改变当前组件的尺寸
          switch (this.pressDirection) {
            case clickPositionEnum.Right:
            // 当拖动方向为右边时，设置当前组件的宽度为触摸点的x坐标
              this.currentComponentWidth = event.touches[0].x
              break
            case clickPositionEnum.Bottom:
            // 当拖动方向为底部时，设置当前组件的高度为触摸点的y坐标
              this.currentComponentHeight = event.touches[0].y
              break
            case clickPositionEnum.Left:
            // 当拖动方向为左边时，固定组件的右下角位置，并更新宽度
              this.isFixedX = true
              this.activeX = event.touches[0].x + this.mainWindowX
              this.currentComponentWidth = this.originalWidth - event.touches[0].x
              break
            case clickPositionEnum.Top:
            // 当拖动方向为顶部时，固定组件的右下角位置，并更新高度
              this.isFixedY = true
              this.activeY = event.touches[0].y + this.mainWindowY
              this.currentComponentHeight = this.originalHeight - event.touches[0].y
              break
            case clickPositionEnum.TopRight:
            // 当拖动方向为右上角时，固定组件的y坐标，并更新宽度和高度
              this.isFixedY = true
              this.activeY = event.touches[0].y + this.mainWindowY
              this.currentComponentWidth = event.touches[0].x
              this.currentComponentHeight = this.originalHeight - event.touches[0].y
              break
            case clickPositionEnum.BottomRight:
            // 当拖动方向为右下角时，更新宽度和高度
              this.currentComponentWidth = event.touches[0].x
              this.currentComponentHeight = event.touches[0].y
              break
            case clickPositionEnum.TopLeft:
            // 当拖动方向为左上角时，固定组件的x和y坐标，并更新宽度和高度
              this.isFixedY = true
              this.isFixedX = true
              this.activeX = event.touches[0].x + this.mainWindowX
              this.activeY = event.touches[0].y + this.mainWindowY
              this.currentComponentWidth = this.originalWidth - event.touches[0].x
              this.currentComponentHeight = this.originalHeight - event.touches[0].y
              break
            case clickPositionEnum.BottomLeft:
            // 当拖动方向为左下角时，固定组件的x坐标，并更新宽度和高度
              this.isFixedX = true
              this.activeX = event.touches[0].x + this.mainWindowX
              this.currentComponentWidth = this.originalWidth - event.touches[0].x
              this.currentComponentHeight = event.touches[0].y
              break
          }

          // 宽高合法化,防止宽高为负值
          if (this.isFixedX && this.currentComponentWidth! < 30) {
            // 处理固定定位改变的变量
            this.activeX = this.originalWidth + this.mainWindowX - 30
          }
          if (this.isFixedY && this.currentComponentHeight! < 30) {
            // 处理固定定位改变的变量
            this.activeY = this.originalHeight + this.mainWindowY - 30
          }

          // 限制组件的最小尺寸
          this.currentComponentWidth = Math.max(this.currentComponentWidth!, 30);
          this.currentComponentHeight = Math.max(this.currentComponentHeight!, 30);

          // 规范区域大小，防止组件超出父元素边界
          if (!this.isFixedX && this.mainWindowX + event.touches[0].x >= this.parentComponentWidth) {
            this.currentComponentWidth =
              Math.min(this.currentComponentWidth!, this.parentComponentWidth - this.mainWindowX);
          }
          if (!this.isFixedY && this.mainWindowY + event.touches[0].y >= this.parentComponentHeight) {
            this.currentComponentHeight =
              Math.min(this.currentComponentHeight!, this.parentComponentHeight - this.mainWindowY);
          }

          // 确保组件的坐标不会小于0
          if (this.activeX <= 0 && this.isFixedX) {
            this.activeX = 0;
            this.currentComponentWidth = this.originalWidth + this.mainWindowX;
          }
          if (this.activeY <= 0 && this.isFixedY) {
            this.activeY = 0;
            this.currentComponentHeight = this.originalHeight + this.mainWindowY;
          }

        }

      }
    })
  }
}