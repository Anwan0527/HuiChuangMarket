import { Log } from '@abner/log'
import { promptAction, router } from '@kit.ArkUI'
import { addCartAPI, getGoodsDetail, Result as DetailResult } from '../api/detail'
import { SkuCom } from '@fine/sku-component'
import { LoadingCom } from '@CH/common/Index'
import { emitter } from '@kit.BasicServicesKit'

interface RouteParams {
  id: string
}

const bannerList: string[] =
  new Array<string>(4).fill('http://yjy-xiaotuxian-dev.oss-cn-beijing.aliyuncs.com/picture/2021-04-05/dafec715-761b-438b-afc8-1e3f55bf3c1c.png')

@Entry
@Component
struct GoodsDetailPage {
  listScroller: Scroller = new Scroller()
  tabList: string[] = ['商品', '详情']
  // 有意识的区分响应式状态和普通状态
  // 每一个@State修饰的属性都是需要时间处理成响应式的  影响初始化的性能
  @State activeIndex: number = 0
  swiperController: SwiperController = new SwiperController()
  @State swipperIndex: number = 0
  @State count: number = 0
  @State goodsDetail: DetailResult | null = null
  getGoodsDetail = async (id: string) => {
    try {
      const res = await getGoodsDetail(id)
      this.goodsDetail = res.data.result
      Log.info(this.goodsDetail)
    } catch (e) {
    }
  }
  @State showSku: boolean = false
  skuId: string | null = null
  addCart = async () => {
    // 判断当前是否选择合法的商品规格 + 数量是否大于零
    if (this.skuId === null || this.count === 0) {
      promptAction.showToast({ message: '请选择合法和规格和数量' })
    } else {
      // 添加购物车操作
      try {
        await addCartAPI(this.skuId, this.count)
        promptAction.showToast({ message: '添加购物车成功' })
        // 通知购物车列表进行更新
        emitter.emit('updateCartList')
      } catch (e) {
        Log.error(e)
      }
    }
  }
  skuChange = (skuId: string | null) => {
    this.skuId = skuId
    Log.info(this.skuId)
  }

  aboutToAppear(): void {
    const params = router.getParams() as RouteParams
    if (params) {
      Log.info(params.id)
      this.getGoodsDetail(params.id)
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


      Column() {
        Scroll() {
          Column() {
            List({
              scroller: this.listScroller
            }) {
              ListItem() {
                Column() {
                  Stack({ alignContent: Alignment.BottomEnd }) {
                    // 主体内容区域
                    Swiper(this.swiperController) {
                      ForEach(
                        this.goodsDetail?.mainPictures,
                        (url: string) => {
                          Image(url).aspectRatio(360 / 310)
                        })
                    }
                    .loop(true)
                    .autoPlay(true)
                    .indicator(false)
                    .onChange((index) => {
                      this.swipperIndex = index
                    })

                    Row() {
                      Text(`${this.swipperIndex + 1}/${this.goodsDetail?.mainPictures.length}`)
                        .fontColor('#A6A3AD')
                        .fontSize(11)
                    }
                    .width(36)
                    .height(16)
                    .borderRadius(10)
                    .backgroundColor('#F5F4F9')
                    .margin({ bottom: 10, right: 10 })
                    .justifyContent(FlexAlign.Center)
                  }

                  // 商品信息区域
                  Column() {
                    // 价格
                    Text(`${this.goodsDetail?.price}`).fontSize(25).fontColor('#191919')
                    // 标题
                    Text(this.goodsDetail?.name)
                      .lineHeight(20)
                      .fontSize(15)
                      .fontColor('#434343')

                    Text('保暖升级，舒适亲肤')
                      .fontSize(12)
                      .lineHeight(20)
                      .fontColor('#A6A3AD')

                    Row() {
                      Text('已选')
                        .fontSize(12)
                      Text('请选择')
                        .margin({ left: 16 })
                        .fontSize(12)
                        .fontColor('#A6A3AD')
                        .onClick(() => {
                          this.showSku = true
                        })
                        .bindSheet(
                          $$this.showSku,
                          this.skuBuilder(),
                          {
                            height: SheetSize.FIT_CONTENT, // 适应内容
                            backgroundColor: '#fff',
                          }
                        )
                    }
                    .width('100%')
                    .height(40)
                    .alignItems(VerticalAlign.Center)
                    .border({
                      width: {
                        bottom: 1
                      },
                      color: '#eee'
                    })

                    Text('无忧退货 · 快速退款 · 免费包邮')
                      .padding({ top: 10, bottom: 10 })
                      .fontSize(12)
                      .fontColor('#191919')
                  }
                  .borderRadius(10)
                  .padding({ left: 8, right: 8, top: 20 })
                  .alignItems(HorizontalAlign.Start)
                  .backgroundColor('#fff')
                  .margin(8)
                }
              }

              ListItem() {
                // 详情区域
                Column() {
                  Row() {
                    Text('商品信息').fontSize(12).fontWeight(700)
                  }
                  .width('100%')
                  .height(56)
                  .padding({ left: 10 })

                  Column() {
                    ForEach(
                      this.goodsDetail?.details.pictures,
                      (url: string) => {
                        Image(url).width('100%')
                      }
                    )
                  }
                }
                .width('100%')
                .backgroundColor('#fff')
                .visibility(this.goodsDetail?.details.pictures.length ? Visibility.Visible : Visibility.None)
              }
            }
            .width("100%")
            .height("100%")
            .onScrollIndex(index => {
              this.activeIndex = index
            })
          }
        }
      }
      .layoutWeight(1)
      .backgroundColor('#F5F4F9')

    }
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
      this.listScroller.scrollToIndex(this.activeIndex)
    })
  }

  @Builder
  skuBuilder() {
    Column() {
      Column() {
        // 内容区域
        Column() {
          if (this.goodsDetail !== null) {
            // 商品图片和价格
            Row() {
              // 商品图
              Image(this.goodsDetail.mainPictures[0]).width(90).aspectRatio(1)
              // 商品价格
              Text('￥' + this.goodsDetail.price)
                .margin({
                  left: 20
                })
                .fontSize(22)
                .fontWeight(700)
            }
            .height(90)
            .width('100%')
            .margin({
              top: 20,
              bottom: 20
            })
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Bottom)

            // sku组件
            SkuCom({
              goods: {
                skus: this.goodsDetail.skus,
                specs: this.goodsDetail.specs,
              },
              onSkuChange: (skuId: string) => {
                this.skuChange(skuId)
                this.skuId = skuId
              }
            })

            // 数量区域
            Row() {
              Row() {
                Text('数量').margin({ right: 10 }).fontSize(13).fontWeight(500)
                Text(`库存${this.goodsDetail.inventory}`).fontSize(12)
              }

              Counter() {
                Text(this.count.toString()).fontSize(12)
              }
              .size({ height: 28 })
              .onInc(() => {
                this.count++
              })
              .onDec(() => {
                if (this.count === 0) {
                  return
                }
                this.count--
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
        }
        .width('100%')
        .layoutWeight(1)

        // 数量按钮区域
        Row() {
          Row() {
            Text('加入购物车').fontColor('#fff').fontSize(14)
          }
          .onClick(() => {
            this.addCart()
          })
          .height('100%')
          .backgroundColor('#191919')
          .justifyContent(FlexAlign.Center)
          .layoutWeight(1)
          .borderRadius(18)
        }
        .height(36)
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 16 })
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor('#fff')
    }
    .height('100%')
    .justifyContent(FlexAlign.End)
  }
}