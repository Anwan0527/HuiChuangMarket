import { Log } from '@abner/log'
import { BannerItemType, getBannerListAPI } from '../apis/banner'

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

  aboutToAppear() {
    this.GetGoodsList()
  }

  build() {
    Column() {
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
    }
    .width('100%')
  }
}