import { MainPage as Home } from '@CH/home'
import { MainPage as Category } from '@CH/category'
import { MainPage as My } from '@CH/My'
import { MainPage as Cart } from '@CH/Cart'


@Entry
@Component
struct Index {
  @State activeIndex: number = 0

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.activeIndex }) {
      TabContent() {
        Home()
      }
      .tabBar(this.TabBarBuilder('首页', $r("app.media.ic_public_home_normal"), $r("app.media.ic_public_home_actived"),
        0))

      TabContent() {
        Category()
      }
      .tabBar(this.TabBarBuilder('分类', $r("app.media.ic_public_pro_normal"), $r("app.media.ic_public_pro_actived"),
        1))

      TabContent() {
        Cart()
      }
      .tabBar(this.TabBarBuilder('购物袋', $r("app.media.ic_public_cart_normal"),
        $r("app.media.ic_public_cart_actived"),
        2))

      TabContent() {
        My()
      }
      .tabBar(this.TabBarBuilder('我的', $r("app.media.ic_public_my_normal"), $r("app.media.ic_public_my_actived"), 3))
    }
    .barMode(BarMode.Fixed)
    .scrollable(false)
  }

  @Builder
  TabBarBuilder(text: string, icon: Resource, activeIcon: Resource, index: number) {
    Column() {
      // icon
      Image(this.activeIndex === index ? activeIcon : icon).width(22).width(22)
      // text
      Text(text).fontSize(11).fontColor(this.activeIndex === index ? '#191919' : '#6B6B6B')
    }
    .onClick(() => {
      this.activeIndex = index
    })
  }
}