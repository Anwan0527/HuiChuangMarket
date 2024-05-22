import { MainPage as Home } from '@CH/home'
import { MainPage as Cart } from '@CH/Cart'
import { MainPage as Category } from '@CH/category'
import { MainPage as My } from '@CH/My'

// tab点击切换交互实现
// 通用的实现思路 点击哪个哪个就激活
// 1. 点击哪个记录一下当前的点击项（id / index）
// 2. 比较第一步记录下来的index和每一项的index是否相等 如果相等，当前项就应该被激活 [ 0, 1, 2, 3 ]
// 3. 把找到的那个激活项通过样式的变化显示到UI上

import { OrientationState, CheckLandscape, Auth } from '@CH/common'

Auth.initLocalUser()

@Entry
@Component
struct Index {
  @State activeIndex: number = 0
  @State isLand: boolean = false

  @Builder
  TabsContent(landState: OrientationState) {
    Tabs({ barPosition: landState.isLand ? BarPosition.Start : BarPosition.End, index: this.activeIndex }) {
      TabContent() {
        Home()
      }
      .tabBar(this.TabBuilder('首页', $r('app.media.ic_public_home_normal'), $r('app.media.ic_public_home_actived'), 0))

      TabContent() {
        Category()
      }
      .tabBar(this.TabBuilder('分类', $r('app.media.ic_public_pro_normal'), $r('app.media.ic_public_pro_actived'), 1))

      TabContent() {
        Cart()
      }
      .tabBar(this.TabBuilder('购物袋', $r('app.media.ic_public_cart_normal'), $r('app.media.ic_public_cart_actived'),
        2))

      TabContent() {
        My()
      }
      .tabBar(this.TabBuilder('我的', $r('app.media.ic_public_my_normal'), $r('app.media.ic_public_my_actived'), 3))
    }
    .scrollable(false)
    .vertical(landState.isLand)
  }

  build() {
    Column() {
      // 自定义builder 传参的方式适配
      // 1. 通过媒体查询 检测当前是否是横屏
      // 2. 根据检测到的结果控制tabs某个属性
      CheckLandscape({
        Solt: (OrientationState) => {
          this.TabsContent(OrientationState)
        }
      })
    }
  }

  @Builder
  TabBuilder(text: string, normalIcon: Resource, activeIcon: Resource, index: number) {
    Column() {
      Image(this.activeIndex === index ? activeIcon : normalIcon).width(24)
      Text(text)
        .fontColor(this.activeIndex === index ? '#191919' : '#6B6B6B')
        .fontSize(12)
    }
    .width('100%')
    .onClick(() => {
      // 当前index赋值给activeIndex
      this.activeIndex = index
      console.log(this.activeIndex.toString())
    })
  }
}