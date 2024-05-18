import { Log } from '@abner/log'
import { BannerItemType, getBannerListAPI } from '../apis/banner'
import { router } from '@kit.ArkUI'

@Entry
@Component
export struct HomeBanner {
  @State bannerList: BannerItemType[] = []
  GetGoodsList = async () => {
    try {
      const res = await getBannerListAPI()
      this.bannerList = res.data.result
    } catch (e) {
      Log.error(e)
    }
  }
  private swiperController: SwiperController = new SwiperController()

  //搜索Builder
  @Builder
  SearchBuilder() {
    Column() {
      Row({
        space: 10
      }) {
        Image($r('app.media.home_input_search'))
          .width(16)
        Text("搜索...")
          .fontSize(14)
          .fontColor(Color.White)
      }
      .onClick(() => {
        router.pushUrl({
          url: 'pages/SearchPage'
        })
      })
      .width("100%")
      .height(40)
      .backgroundColor("#1919194d")
      .borderRadius(20)
      .padding({
        left: 12
      })
    }
    .padding({
      left: 15, right: 15,
      top: 12
    })

  }

  aboutToAppear() {
    this.GetGoodsList()
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Top }) {
        Swiper(this.swiperController) {
          ForEach(
            this.bannerList,
            (item: BannerItemType) => {
              Image(item.imgUrl)
                .width('100%')
                .aspectRatio(360 / 240)
            }
          )
        }
        .loop(true)
        .indicator(
          Indicator.dot()
            .itemWidth(8)
            .selectedItemWidth(24)
            .selectedColor('#191919')
        )

        //搜索Builder
        this.SearchBuilder()

      }

    }
    .width('100%')
  }
}
