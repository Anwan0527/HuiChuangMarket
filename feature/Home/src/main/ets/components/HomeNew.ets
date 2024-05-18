import { Log } from '@abner/log'
import { getNewGoodsListAPI, NewGoodsItemType } from '../apis/new'

@Entry
@Component
export struct HomeNew {
  @State
  newGoodsList: NewGoodsItemType[] = []
  getNewGoodsList = async () => {
    try {
      const res = await getNewGoodsListAPI()
      this.newGoodsList = res.data.result
    } catch (e) {
      Log.error(e)
    }
  }

  aboutToAppear() {
    this.getNewGoodsList()
  }

  build() {
    // 新鲜好物
    Column() {
      Column() {
        Row() {
          Image($r('app.media.home_new_icon'))
            .width(150)
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)

        // 列表区域
        Row() {
          GridRow({
            columns: 4,
            gutter: 8
          }) {
            ForEach(
              this.newGoodsList,
              (item: NewGoodsItemType) => {
                GridCol() {
                  Column() {
                    Image(item.picture).aspectRatio(1)
                    Text(`￥${item.price}`)
                      .fontSize(13)
                      .fontColor('#FF4B61')
                      .fontWeight(700)
                      .margin({ top: 10 })
                  }
                  .padding(8)
                  .borderRadius(10)
                  .backgroundColor('#fff')

                }.layoutWeight(1)
              }
            )
          }
        }
        .margin({
          top: 10
        })
      }
      .width('100%')
      .borderRadius(8)
      .backgroundColor('#f8eff4')
      .padding(8)
      .margin({ top: 8, bottom: 8 })
      .alignItems(HorizontalAlign.Start)
    }
    .padding({
      left: 8,
      right: 8
    })
  }
}