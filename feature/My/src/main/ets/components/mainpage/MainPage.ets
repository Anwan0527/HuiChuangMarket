import { GoodsItemType, GridRowList, UserType, USER_KEY } from '@CH/common/Index'
import { router } from '@kit.ArkUI'
import { getLikeListAPI, Item } from '../../api'
import { Log } from '@abner/log'

interface ListItem {
  name: string
  icon?: string | Resource
  page?: string
}

@Component
export struct MainPage {
  orderList: ListItem[] = [
    {
      name: '我的订单',
      icon: $r("app.media.ic_my_orlder"),
      page: 'OrderPage'
    },
    {
      name: '在线客服',
      icon: $r("app.media.ic_my_servic"),
      page: 'CustomerServicePage'
    }
  ]
  // 获取全局的用户数据
  @StorageLink(USER_KEY) userInfo: UserType = {} as UserType
  @State likeList: GoodsItemType[] = []
  getLikeList = async () => {
    const res = await getLikeListAPI()

    Log.info(res.data.result.items)
    this.likeList = res.data.result.items
  }

  aboutToAppear(): void {
    this.getLikeList()
  }

  build() {
    Column() {
      // 顶部栏
      this.TopContentBuilder()

      // 个人信息
      this.UserInfoBuilder()

      // 列表区
      this.OrderListBuilder()

      // 猜你喜欢
      this.GuessListBuilder()

    }
    .width('100%')
    .backgroundColor('#F5F4F9')
  }

  @Builder
  TopContentBuilder() {
    Row() {
      Image($r("app.media.ic_my_settings")).width(24)
    }
    .height(56)
    .width('100%')
    .justifyContent(FlexAlign.End)
    .padding({
      right: 14
    })
    .onClick(() => {
      router.pushUrl({
        url: 'pages/SettingPage'
      })
    })
  }

  @Builder
  UserInfoBuilder() {
    Row() {
      Row() {
        Image(this.userInfo.avatar)
          .width(40)
          .aspectRatio(1)
          .borderRadius(20)

      }.backgroundColor('#D9D9D9').borderRadius(20)

      if (this.userInfo?.token) {

        Text(this.userInfo.account)
          .fontSize(18)
          .fontWeight(500)
          .margin({ left: 20 })
      } else {
        Text('去登录')
          .margin({ left: 10 })
          .fontColor('#191919')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/LoginPage'
            })
          })
      }
    }
    .width('100%')
    .height(60)
    .padding({ left: 16 })
  }

  // 订单和客服
  @Builder
  OrderListBuilder() {
    Column() {
      Row() {
        ForEach(
          this.orderList,
          (item: ListItem) => {
            Column() {
              Image(item.icon).width(24)
              Text(item.name).fontSize(12).margin({ top: 10 })
            }
            .layoutWeight(1)
            .onClick(() => {
              router.pushUrl({
                url: `pages/${item.page}`
              })
            })
          }
        )
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: 40,
        right: 40,
        bottom: 10,
        top: 10
      })
      .backgroundColor('#fff')
      .borderRadius(10)
    }
    .width('100%')
    .padding({
      left: 10,
      right: 10,
      bottom: 20,
      top: 20
    })
  }

  // 猜你喜欢
  @Builder
  GuessListBuilder() {
    Column() {
      // 猜你喜欢内容
      Scroll() {
        // 猜你喜欢内容
        GridRowList({
          list: this.likeList
        })
      }
    }
    .padding({ left: 10, right: 10 })
    .layoutWeight(1)
  }
}
