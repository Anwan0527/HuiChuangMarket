import { TitleBar } from '@CH/common/Index'
import { Result as CartItemType, mockCartList } from '../../api'
import { AlertDialog } from '@ohos.arkui.advanced.Dialog'
import { promptAction, router } from '@kit.ArkUI'
import { Log } from '@abner/log'
import { changeAllCartSelectedAPI, changeCartSelectedAPI, delCartAPI, getCartListAPI } from '../../api/cart'
import { emitter } from '@kit.BasicServicesKit'

@Observed
class CartItem {
  attrsText: string
  count: number
  discount: null
  id: string
  isCollect: boolean
  isEffective: boolean
  name: string
  nowOriginalPrice: string
  nowPrice: string = ''
  picture: string
  postFee: number = 0
  price: string
  selected: boolean
  skuId: string
  specs: string[]
  stock: number

  constructor(obj: CartItem) {
    this.attrsText = obj.attrsText
    this.discount = obj.discount
    this.isCollect = obj.isCollect
    this.isEffective = obj.isEffective
    this.id = obj.id
    this.name = obj.name
    this.picture = obj.picture
    this.price = obj.price
    this.nowOriginalPrice = obj.nowOriginalPrice
    this.count = obj.count
    this.selected = obj.selected
    this.skuId = obj.skuId
    this.specs = obj.specs
    this.stock = obj.stock
  }
}

// 做转换
// 目标：[{}] -> [new CartItem()]

function obj2Instance(list: CartItemType[]) {
  return list.map<CartItem>((item: CartItem) => {
    return new CartItem(item)
  })
}

@Component
struct CartItemCom {
  @ObjectLink cartItem: CartItem
  onWhenSingleCheckChange: () => void = () => {
  }

  build() {
    ListItem() {
      Row() {
        // 左侧选择框
        Row() {
          Checkbox() {
          }
          .select(this.cartItem.selected)
          .selectedColor('#FF2737')
          .onClick(() => {
            this.cartItem.selected = !this.cartItem.selected
            this.onWhenSingleCheckChange && this.onWhenSingleCheckChange()
            changeCartSelectedAPI(this.cartItem.skuId, this.cartItem.selected, this.cartItem.count)
          })
        }
        .width(30)

        // 商品缩略图
        Row() {
          Image(this.cartItem.picture)
            .width(80)
        }
        .margin({
          right: 8
        })

        Column() {
          // 商品标题
          Row() {
            Text(this.cartItem.name)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(2)
          }
          .width('100%')

          Row() {
            Text(`￥${this.cartItem.price.toString()}`)
            Counter() {
              Text(this.cartItem.count.toString())
            }
            .width(100)
            .height(30)
            .onInc(() => {
              this.cartItem.count++
            })
            .onDec(() => {
              if (this.cartItem.count === 1) {
                return
              }
              this.cartItem.count--

            })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .layoutWeight(1)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .height(92)
      .padding(8)
    }
  }
}

@Component
export struct MainPage {
  @State
  cartList: CartItem [] = obj2Instance(mockCartList)
  @State isAll: boolean = true
  @State allPrice: number = 0
  //获取列表
  getCartList = async () => {
    try {
      const res = await getCartListAPI()
      this.cartList = obj2Instance(res.data.result)
      this.whenSingleCheckChange()
      this.getAllPrice()
    } catch (e) {
      Log.error(e)
    }
  }
  //计算总价
  getAllPrice = () => {
    this.allPrice = this.cartList
      .filter(item => item.selected)
      .reduce((a, c) => a + c.count * Number(c.price), 0)
  }
  //全选切换
  whenAllCheckChange = () => {
    this.isAll = !this.isAll
    this.cartList.forEach(item => {
      item.selected = this.isAll
    })
    this.getAllPrice()
    changeAllCartSelectedAPI(this.isAll)
  }
  //单选框切换
  whenSingleCheckChange = () => {
    this.isAll = this.cartList.every(item => item.selected)
    this.getAllPrice()
  }
  //删除处理
  delCart = (skuId: string) => {
    const idx = this.cartList.findIndex(cartItem => cartItem.skuId === skuId)
    this.cartList.splice(idx, 1)
    this.getAllPrice()
    this.whenSingleCheckChange()
    delCartAPI([skuId])
  }

  aboutToAppear() {
    this.getCartList()
    emitter.on('updateCartList', () => {
      Log.info('我被通知了，开始更新购物车')
      this.getCartList()
    })
  }

  build() {
    Column() {
      // 头部
      TitleBar({
        title: '购物车',
        showBack: false
      })
      // 购物车列表
      Column() {
        if (this.cartList.length > 0) {
          List() {
            ForEach(
              this.cartList,
              (cartItem: CartItemType) => {
                ListItem() {
                  CartItemCom({
                    cartItem: cartItem,
                    onWhenSingleCheckChange: this.whenSingleCheckChange
                  })
                }.swipeAction({ end: this.ActionBuilder(this.cartList[0]) })

              }
            )
          }
          .width("100%")
          .height("100%")
          .backgroundColor('#fff')
          .divider({
            strokeWidth: 1,
            color: '#eee'
          })
          .edgeEffect(EdgeEffect.None)
        } else {
          Column() {
            Text('购物车是空的')
              .fontSize(12)
              .fontColor('#A6A3AD')
              .margin({
                bottom: 20
              })
            Row() {
              Text('去逛逛').fontColor('#fff').fontSize(12)
            }
            .onClick(async () => {

            })
            .width(76)
            .height(26)
            .justifyContent(FlexAlign.Center)
            .borderRadius(13)
            .linearGradient({
              angle: 93,
              colors: [
                ['#FD3F8F', '0%'],
                ['#FF773C', '100%']
              ]
            })
          }
          .padding({
            top: 20
          })
        }
      }
      .padding(10)
      .backgroundColor('#F5F4F9')
      .width('100%')
      .layoutWeight(1)


      // 尾部操作栏
      Row() {
        Row() {
          Checkbox() {
          }
          .onClick(() => {
            this.whenAllCheckChange()

          })
          .select(this.isAll)
          .selectedColor('#FF2737')

          Text('全选')
        }
        .margin({
          right: 20
        })

        Row() {
          Text(`合计:￥${this.allPrice.toFixed(2)}`)
          Button('提交订单')
            .backgroundColor('#FF2737')
            .fontSize(14)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/OrderConfirmPage'
              })
            })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .height(56)
      .backgroundColor('#fff')
      .padding({ right: 16, left: 16 })
    }
    .height('100%')
  }

  // 右侧操作栏
  @Builder
  ActionBuilder(cartItem: CartItem) {
    Row() {
      Row() {
        Text('删除').fontColor('#fff').fontSize(11).padding({ left: 10, right: 10 })
          .onClick(() => {
            this.delCart(cartItem.skuId)
            // console.log('Log:', cartItem.skuId)
          })
      }
      .backgroundColor('#FF2737')
      .layoutWeight(1)
      .height('100%')
    }
    .width(44)
    .margin({
      left: 10
    })
  }
}
