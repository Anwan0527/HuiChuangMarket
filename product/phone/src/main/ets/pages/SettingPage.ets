import { TitleBar, Auth } from '@CH/common'
import router from '@ohos.router'
import { authentication } from '@kit.AccountKit'
import { util } from '@kit.ArkTS'
import { promptAction } from '@kit.ArkUI'
import { UserType, USER_KEY } from '@CH/common/Index'

@Entry
@Component
struct SettingPage {
  // 获取全局的用户数据
  @StorageLink(USER_KEY) userInfo: UserType = {} as UserType

  build() {
    Column() {
      // 顶部区域
      TitleBar({
        title: '设置',
        showBack: true,
        onBack: () => {
          router.back()
        }
      })

      // 个人信息区域
      Row() {
        // 头像
        Row() {
          Image(this.userInfo.avatar)
        }
        .width(40)
        .height(40)
        .backgroundColor('#D9D9D9')
        .borderRadius(20)

        // 个人信息
        Column() {
          Text(this.userInfo.account)
            .fontSize(16)
            .fontWeight(500)

          Text('账户名: 123456723457')
            .fontSize(12)
            .fontColor('#A6A3AD')
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({
          left: 20
        })

        // 右侧点击按钮
        Row() {
          Image($r("app.media.ic_public_arrow_right")).width(16).fillColor('#A6A3AD')
        }
      }
      .padding(16)
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor('#fff')


      // list区域
      Row() {
        List() {
          ListItem() {
            Row() {
              Text('收货地址管理')
                .fontSize(14)
              Image($r("app.media.ic_public_arrow_right"))
                .width(16)
                .fillColor('#A6A3AD')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ top: 12, bottom: 12 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/AddressListPage'
              })
            })
          }

          ListItem() {
            Row() {
              Text('账号安全')
                .fontSize(14)
              Image($r("app.media.ic_public_arrow_right")).width(16).fillColor('#A6A3AD')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ top: 12, bottom: 12 })
          }

          ListItem() {
            Row() {
              Text('消息设置')
                .fontSize(14)
              Image($r("app.media.ic_public_arrow_right")).width(16).fillColor('#A6A3AD')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ top: 12, bottom: 12 })
          }

          ListItem() {
            Row() {
              Text('隐私设置')
                .fontSize(14)
              Image($r("app.media.ic_public_arrow_right")).width(16).fillColor('#A6A3AD')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ top: 12, bottom: 12 })
          }

          ListItem() {
            Row() {
              Text('通用设置')
                .fontSize(14)
              Image($r("app.media.ic_public_arrow_right")).width(16).fillColor('#A6A3AD')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ top: 12, bottom: 12 })
          }
        }
        .width('100%')
        .divider({
          strokeWidth: 1,
          color: '#ffe9f0f0'
        })
      }
      .padding({
        left: 16,
        right: 16
      })
      .backgroundColor('#fff')
      .margin({ top: 8 })


      // 退出登录
      Row() {
        List() {
          ListItem() {
            Row() {
              Text('退出登录')
                .fontSize(14)
              Image($r("app.media.ic_public_arrow_right")).width(16).fillColor('#A6A3AD')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ top: 12, bottom: 12 })
          }

          ListItem() {
            Row() {
              Text('取消华为授权登录')
                .fontSize(14)
              Image($r("app.media.ic_public_arrow_right")).width(16).fillColor('#A6A3AD')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ top: 12, bottom: 12 })
          }
        }
      }
      .padding({
        left: 16,
        right: 16
      })
      .backgroundColor('#fff')
      .margin({ top: 8 })
    }
    .height('100%')
    .backgroundColor('#F5F4F9')
  }
}