import { router } from '@kit.ArkUI'

interface HotGoodsType {
  id: string
  name: string
  price: string
  picture: string
}

@Entry
@Component
struct RecommendByHotPage {
  // 轮播图
  swiperController: SwiperController = new SwiperController()

  build() {
    Column() {
      Column() {
        this.topBanner()
        this.swiperContainer()
      }
      .height('80%')
      .justifyContent(FlexAlign.Start)
      .linearGradient({
        angle: 180,
        colors: [
          ['#51E1F8', '0%'],
          ['#F5F4F9', '100%']
        ]
      })

      Row() {
        Row() {
          Text('换一批看看')
            .fontSize(16)
            .fontColor('#fff')
        }
        .width('100%')
        .height(46)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#00C6C6')
      }
      .width('100%')
      .padding({
        left: 16,
        right: 16
      })
      .layoutWeight(1)
      .backgroundColor('#F5F4F9')
    }
  }

  // 顶部banner
  @Builder
  topBanner() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image($r("app.media.ic_public_hot_banner_bg"))
        .width('100%')

      Image($r('app.media.ic_public_arrow_left'))
        .width(24)
        .margin({
          left: 12,
          top: 16
        })
        .onClick(() => router.back())
    }
  }

  @Builder
  swiperContainer() {
    Column() {
      Swiper(this.swiperController) {
        ForEach(
          new Array<HotGoodsType>(3).fill({
            id: '1001',
            name: 'PLAZA STYLE estaa 珍珠款毛绒绒保暖套装【含…',
            price: '289',
            picture: 'http://yjy-xiaotuxian-dev.oss-cn-beijing.aliyuncs.com/picture/2021-04-05/6fdcac19-dd44-442c-9212-f7ec3cf3ed18.jpg'
          }),
          (item: HotGoodsType) => {
            Column() {
              Image(item.picture)
                .width('100%')

              Text(item.name)
                .margin({
                  top: 10
                })
                .fontSize(14)
                .fontColor('#434343')

              Text(`￥${item.price}`)
                .margin({
                  top: 10
                })
                .fontSize(20)
                .fontColor('#191919')
                .fontWeight(700)
            }
            .padding(30)
            .backgroundColor('#fff')
          }
        )
      }
      .width(270)
      .borderRadius(16)
      .indicator(
        new DotIndicator()
          .itemWidth(6)
          .itemHeight(6)
          .selectedItemWidth(6)
          .selectedItemHeight(6)
          .color('#E9E8EC')
          .selectedColor('#191919')
      )
    }
    .margin({
      top: -60
    })
  }
}