import { Log } from '@abner/log'
import { router } from '@kit.ArkUI'

interface RouteParams {
  id: string
}

@Entry
@Component
struct GoodsDetailPage {
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

        Row() {
          Tabs() {
            TabContent() {
            }
            .tabBar('商品')

            TabContent() {
            }
            .tabBar('详情')
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
    }
    .height('100%')
    .width('100%')
  }
}