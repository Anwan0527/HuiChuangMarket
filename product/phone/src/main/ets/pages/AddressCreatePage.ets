import router from '@ohos.router'
import { Log } from '@abner/log'
import promptAction from '@ohos.promptAction';
import { TitleBar } from '@CH/common/Index';
import { geoLocationManager } from '@kit.LocationKit';


// 拓展list自定义样式
@Extend(Row)
function listItemStyle() {
  .padding({ top: 4, bottom: 4 })
  .width('100%')
  .justifyContent(FlexAlign.SpaceBetween)
  .backgroundColor('#fff')
}

interface AddressForm {
  receiver: string
  contact: string
  address: string
  isDefault: 0 | 1
  area: string
  detailAddress: string
}

@Entry
@Component
struct CreateAddressPage {
  @State addressForm: AddressForm = {
    receiver: '',
    contact: '',
    address: '',
    area: '',
    detailAddress: '',
    isDefault: 1
  }
  // 准备状态数据
  @State recommendAddress: string = ''

  build() {
    Column() {
      // 顶部区域
      TitleBar({
        title: '新增地址',
        showBack: true,
        onBack: () => router.back()
      })

      // 地址信息表单
      Row() {
        List() {
          ListItem() {
            Row() {
              Text('收货人').width(80).fontSize(14).fontColor('#121826')
              TextInput({ placeholder: '请填写收货人名称', text: this.addressForm.receiver })
                .fontSize(14)
                .backgroundColor('#fff')
                .onChange(val => this.addressForm.receiver = val)
            }
            .listItemStyle()
          }

          ListItem() {
            Row() {
              Text('手机号码').width(80).fontSize(14).fontColor('#121826')
              TextInput({ placeholder: '请填写收货人电话', text: this.addressForm.contact })
                .fontSize(14)
                .backgroundColor('#fff')
                .onChange(val => this.addressForm.contact = val)
            }
            .listItemStyle()
          }

          ListItem() {
            Row() {
              Stack({ alignContent: Alignment.End }) {
                Row() {
                  Text('所在地区').width(80).fontSize(14).fontColor('#121826')
                  TextInput({ placeholder: '请输入所在地区', text: this.addressForm.address })
                    .fontSize(14)
                    .backgroundColor('#fff')
                    .onChange(val => this.addressForm.address = val)
                }

                // 地理位置按钮
                LocationButton({ icon: LocationIconStyle.LINES })
                  .onClick(async (event: ClickEvent, result: LocationButtonOnClickResult) => {
                    // 免去权限申请和权限请求等环节，获得临时授权，获取位置信息授权
                    if (result === LocationButtonOnClickResult.SUCCESS) {
                      try {
                        this.recommendAddress = '地区获取中...'
                        const requestInfo: geoLocationManager.LocationRequest = {
                          'priority': geoLocationManager.LocationRequestPriority.FIRST_FIX,
                          'scenario': geoLocationManager.LocationRequestScenario.UNSET,
                          'timeInterval': 1,
                          'distanceInterval': 0,
                          'maxAccuracy': 0
                        }
                        const location = await geoLocationManager.getCurrentLocation(requestInfo)
                        Log.info(location)

                        // 反解成地址
                        let reverseGeocodeRequest: geoLocationManager.ReverseGeoCodeRequest = {
                          "latitude": location.latitude,
                          "longitude": location.longitude,
                          "maxItems": 3
                        }

                        geoLocationManager.getAddressesFromLocation(reverseGeocodeRequest, (err, data) => {
                          if (err) {
                            Log.info(err)
                          } else {
                            Log.info(data)
                            const item = data[0]
                            this.recommendAddress = `${item.subAdministrativeArea}${item.locality}${item.subLocality}`
                          }
                        })
                      } catch (e) {
                        Log.error(e) // { "code":"3301100" }
                        if (e.code === '3301100') {
                          promptAction.showToast({ message: '请先在设置中打开位置服务' })
                        }
                      }
                    } else {
                      promptAction.showToast({ message: '获取位置信息失败！' })
                    }
                  })
                  .iconColor('#FD3F8F')
              }
            }
            .listItemStyle()
          }

          ListItem() {
            Row() {
              Text('详细地址').width(80).fontSize(14).fontColor('#121826')
              TextInput({ placeholder: '请填写详细地址', text: this.addressForm.detailAddress })
                .fontSize(14)
                .backgroundColor('#fff')
                .onChange(val => this.addressForm.detailAddress = val)


            }
            .listItemStyle()
          }

          ListItem() {
            Row() {
              Text('设为默认地址').fontSize(14).fontColor('#121826')
              Toggle({ isOn: this.addressForm.isDefault === 0 ? true : false, type: ToggleType.Checkbox })
                .selectedColor('#FD3F8F')
                .onChange(val => this.addressForm.isDefault = val ? 0 : 1)
            }
            .listItemStyle()
          }
        }
        .divider({
          strokeWidth: 1,
          color: '#eee'
        })
        .backgroundColor('#fff')
        .padding({ left: 8, right: 8 })
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Top)


      // 底部保存按钮
      Row() {
        Button('保存')
          .backgroundColor('#191919')
          .fontSize(14)
          .width('100%')
      }
      .height(46)
      .padding({ left: 16, right: 16 })
    }
    .height('100%')
    .backgroundColor('#F5F4F9')
  }
}