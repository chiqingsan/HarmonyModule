@Entry
@Component
struct RowList {
  @State message: string = 'Hello World';
  scrollController: Scroller = new Scroller()
  @State arr: string[] = new Array(3).fill("")

  build() {
    Row() {
      List({ scroller: this.scrollController }) {
        ForEach(
          this.arr,
          (item: string, index) => {
            ListItem() {
              Column() {
                Text(index.toString())
              }.height("100%").width("33%").backgroundColor("#cde")
            }
          }
        )
      }.listDirection(Axis.Horizontal)
      .onScroll((index, state) => {
        console.log("RowList_index,state:", JSON.stringify(index), JSON.stringify(state))

      })
    }.width("100%").height(100).backgroundColor("#ddd")
  }
}