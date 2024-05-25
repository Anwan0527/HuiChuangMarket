import { TitleBar } from '@CH/common/Index'
import { promptAction, router } from '@kit.ArkUI'
import { AddressItemType, delAddressAPI, getAddressListAPI, updateAddressAPI } from '../api/address'
import { Log } from '@abner/log'

@Entry
@Component
struct AddressManagePage {
  @State addressList: AddressItemType[] = []
  getAddressList = async () => {
    try {
      const res = await getAddressListAPI()
      this.addressList = res.data.result
    } catch (e) {
      Log.error(e)
    }
  }
  setDefault = async (id: string) => {
    try { //1.调用接口
      await updateAddressAPI(id)
      //2.更新列表
      this.getAddressList()
      //3.轻提示
      promptAction.showToast({
        message: '设置默认地址成功'
      })
    } catch (e) {
      Log.error(e)
    }
  }
  delAddress = async (id: string) => {
    //1.调用接口
    await delAddressAPI(id)
    //2.更新列表
    this.getAddressList()
    //3.轻提示
    promptAction.showToast({
      message: '删除地址成功'
    })
  }

  aboutToAppear(): void {
    this.getAddressList()
  }

  build() {
    Column() {
      // 顶部区域
      TitleBar({
        title: '收货地址管理',
        showBack: true,
        onBack: () => router.back()
      })

      // 地址列表
      Row() {
        List() {
          ForEach(
            this.addressList,
            (item: AddressItemType) => {
              ListItem() {
                Row() {
                  Column() {
                    Row() {
                      // 是否默认
                      if (item.isDefault === 0) {
                        Row() {
                          Text('默认').fontSize(13).fontColor('#fff')
                        }
                        .borderRadius(2)
                        .padding({
                          left: 8,
                          right: 8,
                          top: 2,
                          bottom: 2
                        })
                        .linearGradient({
                          angle: '93',
                          colors: [
                            [
                              '#FD3F8F',
                              '0%'
                            ],
                            [
                              '#FF773C',
                              '100%'
                            ]
                          ]
                        })
                        .margin({
                          right: 4
                        })
                      }

                      Text(item.address.split(',')[0])
                        .fontColor('#434343')
                        .fontSize(14)

                    }

                    Text(item.address.split(',')[1])
                      .margin({ top: 8 })
                      .fontSize(16)
                      .fontWeight(500)


                    Text(`${item.receiver} ${item.contact}`)
                      .margin({ top: 8 })
                      .fontSize(12)
                  }
                  .alignItems(HorizontalAlign.Start)

                  Row() {
                    Image($r("app.media.ic_public_edit")).width(16)
                  }
                }
                .padding(16)
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
                .backgroundColor('#fff')
              }
              .margin({ bottom: 10 })
              .swipeAction({
                end: this.ActionBuilder(item.id)
              })
            }
          )
        }
        .width('100%')
        .height('100%')
      }
      .margin({ top: 8 })
      .padding({ left: 8, right: 8 })
      .layoutWeight(1)
      .alignItems(VerticalAlign.Top)

      // 底部新增地址
      Row() {
        Button('新增地址')
          .backgroundColor('#191919')
          .fontSize(14)
          .width('100%')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/AddressCreatePage'
            })
          })
      }
      .height(46)
      .padding({ left: 16, right: 16 })
    }
    .height('100%')
    .backgroundColor('#F5F4F9')
  }

  @Builder
  ActionBuilder(id: string) {
    Row() {
      Row() {
        Text('设为默认').fontColor('#fff').fontSize(11).padding({ left: 10, right: 10 })
      }
      .layoutWeight(1)
      .height('100%')
      .backgroundColor('#000')
      .onClick(() => {
        this.setDefault(id)
      })

      Row() {
        Text('删除').fontColor('#fff').fontSize(11).padding({ left: 10, right: 10 })
      }
      .backgroundColor('#FF2737')
      .layoutWeight(1)
      .height('100%')
      .onClick(() => {
        this.delAddress(id)
      })
    }
    .width(88)
  }
}