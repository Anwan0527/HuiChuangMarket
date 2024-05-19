import { Auth, TitleBar,  } from '@CH/common';
import { promptAction, router } from '@kit.ArkUI';
import { loginAPI, LoginReqDataType } from '../api/login';

interface LoginFormType {
  account: string,
  password: string
}

@Entry
@Component
struct LoginPage {
  loginForm: LoginReqDataType = {
    account: 'zhousg',
    password: '123456'
  }
  @State isAgree: boolean = false
  loginHandler = async () => {
    // 判断是否同意协议
    if (!this.isAgree) {
      return promptAction.showToast({
        message: '请先勾选协议'
      })
    } else {
      // 调用接口
      try {
        const res = await loginAPI(this.loginForm)
        // 存入全局内存
        Auth.setUser(res.data.result)
        promptAction.showToast({
          message: '登录成功'
        })
        router.pushUrl({
          url: 'pages/Index'
        })
      } catch (e) {
        console.error('fetch login error:', e)
      }
    }
  }

  build() {
    Column() {
      // 顶部区域
      TitleBar({
        title: '登录',
        showBack: true,
        onBack: () => {
          router.back()
        }
      })

      // 表单区域
      Column() {
        // 账号
        TextInput({ placeholder: '请输入手机号', text: this.loginForm.account })
          .margin({ top: 20 })
          .fontSize(14)
          .fontColor('#191919')
          .onChange((value) => {
            this.loginForm.account = value
          })
        // 密码
        TextInput({ placeholder: '请输入密码', text: this.loginForm.password })
          .margin({ top: 20 })
          .fontSize(14)
          .fontColor('#A6A3AD')
          .onChange((value) => {
            this.loginForm.password = value
          })
        Button('登录')
          .width('100%')
          .fontSize(14)
          .backgroundColor('#191919')
          .margin({ top: 20 })
          .onClick(() => {
            this.loginHandler()
          })
        // 协议
        Row() {
          Toggle({ type: ToggleType.Checkbox, isOn: this.isAgree })
            .size({ width: 10 })
            .selectedColor('#191919')
            .onChange((value) => {
              this.isAgree = value
            })
          Text('查看并同意《隐私条款》和《用户协议》')
            .fontSize(12)
            .fontColor('#A6A3AD')
        }
        .margin({
          top: 4
        })
      }
      .alignItems(HorizontalAlign.Start)
      .padding({
        left: 24,
        right: 24,
        top: 30
      })
    }
  }
}