import { Log } from '@abner/log'
import { router } from '@kit.ArkUI'

interface RouteParams {
  id: string
}

const bannerList: string[] =
  new Array<string>(4).fill('http://yjy-xiaotuxian-dev.oss-cn-beijing.aliyuncs.com/picture/2021-04-05/dafec715-761b-438b-afc8-1e3f55bf3c1c.png')

@Entry
@Component
struct GoodsDetailPage {
  tabList: string[] = ['商品', '详情']
  // 有意识的区分响应式状态和普通状态
  // 每一个@State修饰的属性都是需要时间处理成响应式的  影响初始化的性能
  @State activeIndex: number = 0
  swiperController: SwiperController = new SwiperController()
  @State swipperIndex: number = 0

  aboutToAppear(): void {
    const params = router.getParams() as RouteParams
    if (params) {
      Log.info(params.id)
    }
  }

  build() {
    Column() {
      // 顶部区域
      Row() {
        Row() {
          Image($r('app.media.arrow_left'))
            .width(24)
        }
        .width(50)
        .justifyContent(FlexAlign.Center)
        .height('100%')
        .onClick(() => {
          router.back()
        })

        Row() {
          Tabs() {
            ForEach(
              this.tabList,
              (tab: string, index: number) => {
                TabContent() {
                }
                .tabBar(this.TabBarBuilder(tab, index))
              }
            )
          }
        }
        .layoutWeight(1)

        // Row() {
        //   Image($r('app.media.ic_public_share'))
        //     .width(20)
        // }
        // .width(50)
        // .height('100%')
        // .justifyContent(FlexAlign.Center)
      }
      .height(56)

      Stack({ alignContent: Alignment.BottomEnd }) {
        // 主体内容区域
        Swiper(this.swiperController) {
          ForEach(
            bannerList,
            (url: string) => {
              Image(url).aspectRatio(360 / 310)
            }
          )
        }
        .loop(true)
        .autoPlay(true)
        .indicator(false)
        .onChange((index) => {
          this.swipperIndex = index
        })

        Row() {
          Text(`${this.swipperIndex + 1}/${bannerList.length}`).fontColor('#A6A3AD').fontSize(11)
        }
        .width(36)
        .height(16)
        .borderRadius(10)
        .backgroundColor('#F5F4F9')
        .margin({ bottom: 10, right: 10 })
        .justifyContent(FlexAlign.Center)
      }
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  TabBarBuilder(tabName: string, index: number) {
    Row() {
      Text(tabName)
        .fontSize(this.activeIndex === index ? 16 : 14)
        .fontColor(this.activeIndex === index ? '#191919' : '#6B6B6B')
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.activeIndex = index
    })
  }
}