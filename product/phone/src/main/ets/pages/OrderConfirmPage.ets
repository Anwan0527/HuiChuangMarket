import { GoodsItemType, TitleBar } from '@CH/common/Index'
import { Result, UserAddress, getOrderPreAPI, createOrderAPI, OrderGood } from '../api/order'
import { promptAction, router } from '@kit.ArkUI'
import { Log } from '@abner/log'
import { emitter } from '@kit.BasicServicesKit'

@Entry
@Component
struct ConfirmOrderPage {
  @State perOrder: Result | null = null
  @State curAddress: UserAddress | null = null
  @State activeAddress: UserAddress | null = null
  @State
  isShowSheet: boolean = false
  @State
  showPay: boolean = false
  getOrderPre = async () => {
    try {
      const res = await getOrderPreAPI()
      this.perOrder = res.data.result
      //查找默认地址
      const curAddress = this.perOrder.userAddresses.find(item => item.isDefault === 0)
      if (curAddress) {
        this.curAddress = curAddress
      }
    } catch (e) {
      Log.error(e)
    }
  }

  aboutToAppear(): void {
    this.getOrderPre()
  }

  // 构建商品列表Builder
  @Builder
  GoodsListBuilder() {
    List() {
      ForEach(
        this.perOrder?.goods,
        (item: GoodsItemType) => {
          ListItem() {
            Row() {
              // 左图
              Image(item.picture)
                .width(80)
                .aspectRatio(1)
                .margin({ right: 10 })
              // 右侧内容
              Column() {
                // 标题
                Text(item.name)
                  .fontSize(12)
                  .fontColor('#121826')

                // 单价
                Text(`￥${item.price}`).fontSize(14).margin({ top: 10 })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            }
            .alignItems(VerticalAlign.Top)
            .padding(8)
          }
        }
      )

    }
    .width('100%')
    .backgroundColor('#fff')
    .margin({ top: 10 })
    .divider({
      strokeWidth: 1,
      startMargin: 8,
      endMargin: 8
    })
  }

  // 建立价格信息Builder
  @Builder
  PriceInfoBuilder() {
    if (this.perOrder) {
      // 配送时间
      List() {
        ListItem() {
          this.BetweenListBuilder('商品总价', this.perOrder.summary.totalPrice)
        }

        ListItem() {
          this.BetweenListBuilder('运费', this.perOrder.summary.postFee)
        }

        ListItem() {
          this.BetweenListBuilder('实付金额', this.perOrder.summary.totalPayPrice)
        }
      }
      .width('100%')
      .backgroundColor('#fff')
      .margin({ top: 10 })
      .divider({
        strokeWidth: 1,
        startMargin: 8,
        endMargin: 8
      })
    }
  }

  @Builder
  BetweenListBuilder(leftValue: string, rightValue: number) {
    Row() {
      Text(leftValue).fontSize(14).fontColor('#121826')
      Text(`￥${rightValue.toFixed(2)}`).fontSize(12).fontColor('#434343')
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: 8,
      right: 8,
      top: 12,
      bottom: 12
    })
  }

  // Sheet
  @Builder
  BottomActionPayBuilder() {
    Column() {
      Column() {
        Text('支付方式')
          .fontSize(16)
          .fontColor('#191919')
        Text(`￥${this.perOrder?.summary.totalPayPrice}`)
          .fontSize(24)
          .fontWeight(500)
          .margin({ top: 14 })
      }

      Column() {
        Row() {
          Text('支付宝支付')
          Checkbox()
            .selectedColor('#FF2737')
        }
        .width('100%')
        .height(56)
        .justifyContent(FlexAlign.SpaceBetween)
      }

      Button('立即购买')
        .width('100%')
        .backgroundColor('#FF2737')
        .onClick(async () => {
          if (this.curAddress && this.perOrder) {
            const res = await createOrderAPI({
              deliveryTimeType: 1,
              payType: 1,
              payChannel: 1,
              buyerMessage: '',
              goods: this.perOrder?.goods.map<OrderGood>(item => {
                return {
                  skuId: item.skuId,
                  count: item.count
                }
              }),
              addressId: this.curAddress?.id
            })

            promptAction.showToast({
              message: '成功创建订单',
              duration: 500
            })

            // 跳转到支付页
            router.pushUrl({
              url: 'pages/PayPage',
              params: {
                orderId: res.data.result.id
              }
            })
            // 订单状态已发生变化，更新购物车
            emitter.emit('updateCartList')
          }
        })
    }
    .height('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: 18,
      right: 18,
      top: 14,
      bottom: 14
    })
  }

  // 底部操作区域
  @Builder
  BottomActionContainer() {
    if (this.perOrder) {
      // 操作区域
      Row() {
        Text(`￥${this.perOrder.summary.totalPayPrice.toFixed(2)}`).fontColor('#FF2737').fontWeight(600)
        Button('提交订单')
          .width(114)
          .height(36)
          .backgroundColor('#FF2737')
          .fontSize(14)
          .onClick(() => {
            this.showPay = true
          })
          .bindSheet(
            $$this.showPay,
            this.BottomActionPayBuilder(),
            {
              height: 320
            }
          )
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: 16,
        right: 16,
        top: 10,
        bottom: 10
      })
      .margin({
        top: 10
      })
      .backgroundColor('#fff')
    }
  }

  build() {
    Column() {
      TitleBar({
        title: "填写订单",
        showBack: true,
        onBack: () => router.back()
      })
      Column() {
        Column() {
          // 地址区域
          this.AddressContainer()
          // 购物车区域
          this.GoodsListBuilder()
          // 价格信息
          this.PriceInfoBuilder()
        }
        .layoutWeight(1)

        // 底部操作区域
        this.BottomActionContainer()
      }
      .layoutWeight(1)
    }
    .height('100%')
    .backgroundColor('#F5F4F9')
  }

  @Builder
  addressSheet() {
    List() {
      ForEach(
        this.perOrder?.userAddresses,
        (item: UserAddress) => {
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

                  Text(item.address)
                    .fontColor('#434343')
                    .fontSize(14)
                }

                Text(`${item.receiver} ${item.contact}`)
                  .margin({ top: 8 })
                  .fontSize(12)
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Image($r('app.media.ic_public_select_checkbox'))
                .width(20)
                .visibility(this.activeAddress?.id === item.id ? Visibility.Visible : Visibility.None)
            }
            .padding(16)
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .backgroundColor('#fff')
          }
          .onClick(() => {
            this.activeAddress = item
          })
          .margin({ bottom: 10 })
        }
      )
    }
    .width('100%')
    .height('100%')
    .layoutWeight(1)

    Button('确定')
      .onClick((event: ClickEvent) => {
        this.curAddress = this.activeAddress
        this.isShowSheet = false
      })
      .width('100%')
      .height(40)
      .backgroundColor('#000')
      .margin({
        top: 20
      })
  }

  // 地址管理
  @Builder
  AddressContainer() {
    if (this.perOrder) {
      Column() {
        if (this.perOrder.userAddresses.length > 0) {
          // 有地址显示
          Row() {
            Column() {
              Text(this.curAddress?.address.split(',')[0]).fontSize(14).fontColor('#434343').margin({ bottom: 4 })
              Text(this.curAddress?.address.split(',')[1])
                .fontSize(16)
                .fontWeight(500)
                .fontColor('#191919')
                .margin({ bottom: 4 })
              Text(`${this.curAddress?.receiver} ${this.curAddress?.contact}`).fontSize(12)
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)

            Image($r("app.media.ic_public_arrow_right")).width(16)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
          .padding({
            left: 16,
            right: 16,
            top: 10,
            bottom: 10
          })
          .backgroundColor('#fff')
          .onClick(() => {
            this.isShowSheet = true
          })
          .bindSheet(
            $$this.isShowSheet,
            this.addressSheet(),
            {
              height: 400,
              showClose: false,
              title: {
                title: '请选择地址'
              }
            }
          )
        } else {
          // 没地址显示
          Row() {
            Text('请填写收货地址').fontSize(14).fontColor('#A6A3AD')
            Image($r("app.media.ic_public_arrow_right")).width(16)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
          .height(54)
          .padding({ left: 16, right: 16 })
          .backgroundColor('#fff')
        }
      }
    }
  }
}