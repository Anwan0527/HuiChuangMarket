import { TitleBar } from '@CH/common/src/main/ets/components/TitleBar'
import { router } from '@kit.ArkUI'
import { getOrderListAPI, OrderItem, Skus, GetOrderReqType } from '../api/order'
import { Log } from '@abner/log'
import { CountDownCom } from '@CH/common/Index'
import { PullToRefresh } from '@ohos/pulltorefresh'

@Entry
@Component
struct OrderPage {
  @State orderList: OrderItem[] = [
    {
      "id": "1794208025615601665",
      "createTime": "2024-05-25 11:25:03",
      "payType": 1,
      "orderState": 1,
      "payLatestTime": "2024-05-25 11:55:03",
      "postFee": 6.00,
      "payMoney": 605.00,
      "totalMoney": 599.00,
      "totalNum": 1,
      "skus": [
        {
          "id": "1794208025628184577",
          "spuId": "4034793",
          "name": "跟灯按弦超好玩碳纤维智能尤克里里",
          "quantity": 1,
          "image": "https://yanxuan-item.nosdn.127.net/62107ce9769183757d9a425af9f503df.jpg",
          "realPay": 599.00,
          "curPrice": 599.00,
          "totalMoney": null,
          "properties": [
            {
              "propertyMainName": "规格",
              "propertyValueName": "钢琴白-23寸"
            }
          ],
          "attrsText": "规格:钢琴白-23寸 "
        }
      ],
      "payChannel": 1,
      "countdown": 1742
    }, {
    "id": "1794208025615601665",
    "createTime": "2024-05-25 11:25:03",
    "payType": 1,
    "orderState": 1,
    "payLatestTime": "2024-05-25 11:55:03",
    "postFee": 6.00,
    "payMoney": 605.00,
    "totalMoney": 599.00,
    "totalNum": 1,
    "skus": [
      {
        "id": "1794208025628184577",
        "spuId": "4034793",
        "name": "跟灯按弦超好玩碳纤维智能尤克里里",
        "quantity": 1,
        "image": "https://yanxuan-item.nosdn.127.net/62107ce9769183757d9a425af9f503df.jpg",
        "realPay": 599.00,
        "curPrice": 599.00,
        "totalMoney": null,
        "properties": [
          {
            "propertyMainName": "规格",
            "propertyValueName": "钢琴白-23寸"
          }
        ],
        "attrsText": "规格:钢琴白-23寸 "
      }
    ],
    "payChannel": 1,
    "countdown": 1742
  }
  ]
  @State reqParams: GetOrderReqType = {
    page: 1,
    pageSize: 10,
    orderState: 0
  }
  getOrderList = async () => {
    const res = await getOrderListAPI(this.reqParams)
    this.orderList = res.data.result.items
    console.log(JSON.stringify(this.orderList, null, 2))
  }
  private scroller: Scroller = new Scroller()

  @Builder
  listItemBuilder() {
    if (this.orderList) {
      List({ scroller: this.scroller }) {
        ForEach(this.orderList, (item: OrderItem) => {
          ListItem() {
            Column() {
              Row() {
                //日期
                Text(item.createTime)
                  .fontSize(10)
                  .fontColor('#A6A3AD')

                //待付款or待发货
                CountDownCom({
                  initialTime: item.countdown
                })
              }
              .margin({ bottom: 10 })
              .width("100%")
              .justifyContent(FlexAlign.SpaceBetween)

              //图片信息区

              Column({ space: 10 }) {
                ForEach(item.skus, (item: Skus) => {
                  Row() {
                    //左图
                    Image(item.image)
                      .width(80)
                      .aspectRatio(1)
                      .margin({ right: 10 })
                    Column() {
                      Row() {
                        //商品名
                        Row() {
                          Text(item.name)
                            .fontSize(12)
                            .fontColor('#121826')
                        }
                        .layoutWeight(1)

                        // .backgroundColor(Color.Blue)
                        Column() {
                          Text(`￥${item.curPrice.toFixed(2)}`)
                            .fontSize(12)
                            .fontColor('#191919')
                          Text(`x${item.quantity}`)// .width("100%")
                            .fontSize(12)
                            .fontColor('#A6A3AD')
                          // .textAlign(TextAlign.End)
                        }
                        .width(70)
                        .alignItems(HorizontalAlign.End)

                      }
                      .width("100%")
                      .justifyContent(FlexAlign.SpaceBetween)

                      //规格
                      Row() {
                        Text(item.attrsText)
                          .fontSize(12)// .backgroundColor(Color.Blue)
                          .fontColor('#191919')
                      }
                      .width("100%")
                      .justifyContent(FlexAlign.Start)
                      .margin({
                        top: 10
                      })

                      //实付款
                      Row() {
                        //实付款
                        Text(`实付款: ￥${item.realPay.toFixed(2)}`)
                          .fontSize(14)
                          .fontColor('#191919')
                      }

                      .width("100%")
                      .justifyContent(FlexAlign.End)
                      .margin({
                        top: 30
                      })
                    }
                    .layoutWeight(1)
                  }
                  .width("100%")
                  .alignItems(VerticalAlign.Top)
                })
              }


              //按钮
              // 操作按钮区域
              Row() {
                if (item.orderState === 6) {
                  Button('删除订单')
                    .height(30)
                    .fontSize(13)
                    .fontColor('#434343')
                    .backgroundColor('#fff')
                    .border({
                      width: 1,
                      color: '#F5F4F9'
                    })
                    .onClick(() => {
                      AlertDialog.show({
                        title: '确定删除订单？',
                        message: '',
                        buttons: [
                          {
                            value: '取消',
                            backgroundColor: '#fff',
                            fontColor: '#434343',
                            action: () => {
                              console.info('Callback when button1 is clicked')
                            },
                          },
                          {
                            value: '确定',
                            backgroundColor: '#000',
                            fontColor: '#fff',
                            action: () => {
                              console.info('Callback when button2 is clicked')
                            },
                          },
                        ]
                      })
                    })
                }

                if (item.orderState === 1) {
                  Button('立即付款')
                    .height(30)
                    .backgroundColor('#FF2737')
                    .fontSize(13)
                    .onClick(() => {
                      router.pushUrl({
                        url: 'pages/PayPage',
                        params: {
                          orderId: item.id
                        }
                      })
                    })
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.End)
              .margin({ top: 10 })
            }
            .padding(8)
          }
        })
      }
      .padding({
        left: 8,
        right: 8
      })
      .backgroundColor("#fff")
      .width("100%")
      .height("100%")
      //分割线
      .divider({
        strokeWidth: 1,
        color: '#eee',
        startMargin: 8,
        endMargin: 8
      })
      .edgeEffect(EdgeEffect.None) // 必须设置列表为滑动到边缘无效果
    }
  }

  aboutToAppear(): void {
    this.getOrderList()
  }

  build() {
    Column() {
      //1.titlebar   我的订单
      TitleBar({
        title: '我的订单',
        onBack: () => {
          router.back()
        },
        showBack: true
      })
      //2.bar
      Row() {
        Text('占位Bar')
          .width(360)
          .height(56)
          .textAlign(TextAlign.Center)
      }
      .backgroundColor(Color.Gray)

      //3.List
      PullToRefresh({
        // 必传项，列表组件所绑定的数据
        data: $orderList,
        // 必传项，需绑定传入主体布局内的列表或宫格组件
        scroller: this.scroller,
        // 必传项，自定义主体布局，内部有列表或宫格组件
        customList: () => {
          // 一个用@Builder修饰过的UI方法
          this.listItemBuilder()
        },
        // 可选项，上拉加载更多回调
        onLoadMore: async () => {
          this.reqParams.page++
          const res = await getOrderListAPI(this.reqParams)
          this.orderList = this.orderList.concat(res.data.result.items)
          return '加载成功'
        },
        customLoad: null,
        customRefresh: null,
      })

    }
  }
}