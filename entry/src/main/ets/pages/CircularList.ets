interface pictureData {
  imgSrc: ResourceStr
  title: string
}

@Entry
@Component
struct CircularList {
  @State MyPhotoShow: pictureData [] = [
    { imgSrc: $r("app.media.img1"), title: "1" },
    { imgSrc: $r("app.media.img2"), title: "2" },
    { imgSrc: $r("app.media.img3"), title: "3" },
    { imgSrc: $r("app.media.img4"), title: "4" },
    { imgSrc: $r("app.media.img5"), title: "5" },
  ]

  build() {
    Column() {

      Stack() {
        ForEach(
          this.MyPhotoShow,
          (item: pictureData, index) => {
            Stack() {
              Image(item.imgSrc)
                .objectFit(ImageFit.Contain)
              Text(item.title)
            }
            .alignContent(Alignment.BottomStart)
            .width(200)
            .height(100)
            .offset({
              y: 50 * (5 - index)
            })

            // .scale({
            //   x: index / 2,
            //   y: index / 2
            // })
          }
        )

      }

    }.width("100%").height("100%").justifyContent(FlexAlign.Center)
  }
}