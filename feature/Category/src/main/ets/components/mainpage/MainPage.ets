import { CategoryType, getCategoryListAPI } from '../../api/category'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
export struct MainPage {
  @State categoryList: CategoryType[] = []
  getCategoryList = async () => {
    const res = await getCategoryListAPI()
    this.categoryList = res.data.result
  }
  @State activeIndex: number = 0

  aboutToAppear() {
    this.getCategoryList()
  }

  build() {
    Column() {
      //分类title
      Stack({ alignContent: Alignment.TopEnd }) {
        Row() {
          Text('分类')
            .fontSize(17)
          //搜索图片不知道放哪里
        }
        .width("100%")
        .height(56)
        .justifyContent(FlexAlign.Center)

        Image($r('app.media.home_search_left'))
          .width(30)
          .margin(10)
          .onClick(() => {
            //跳转搜索页面
            promptAction.showToast({
              message: '想笑'
            })
          })
      }
      .width("100%")


      Row({
        space: 4
      }) {
        Column() {
          //左边表签
          ForEach(this.categoryList, (item: CategoryType, index: number) => {
            Row() {
              Text(item.name)
                .fontSize(13)
                .fontColor(this.activeIndex == index ? Color.White : Color.Black)
            }
            .backgroundColor(this.activeIndex == index ? Color.Black : Color.White)
            .onClick(() => {
              this.activeIndex = index
            })
            .justifyContent(FlexAlign.Center)
            // .backgroundColor(Color.Pink)
            .width(88)
            .height(56)
            .alignItems(VerticalAlign.Center)
          })
        }

        .height("100%")

        Scroll() {
          Column() {
            //右边内容
            //大图片
            Row() {
              Image(this.categoryList[this.activeIndex]?.picture)
                .aspectRatio(1)
                .borderRadius(24)
              // .backgroundColor(Color.Pink)
            }
            .width("100%")

            //小图片
            GridRow({ columns: { sm: 2, md: 4 } }) {
              ForEach(this.categoryList[this.activeIndex]?.children, (item: CategoryType) => {
                GridCol() {
                  Column() {
                    //图
                    Image(item.picture)
                      .width(64)
                      .height(64)
                    //文字
                    Text(item.name)
                      .fontSize(14)
                      .margin({
                        top: 18
                      })
                  }
                  .backgroundColor("#f6f6f6")
                  .aspectRatio(1)
                  .borderRadius(16)
                  .width("100%")
                  .justifyContent(FlexAlign.Center)
                }
                .margin(4)
              })
            }
            .height("100%")
          }
        }
        // .backgroundColor(Color.Gray)
        .width("100%")
        .layoutWeight(1)
      }

    }
    .width("100%")
    .height("100%")
  }
}
