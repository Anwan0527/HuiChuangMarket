import web_webview from '@ohos.web.webview'
import { router } from '@kit.ArkUI'
import { TitleBar } from '@CH/common'

// 客服地址
const SERVICE_URL = 'https://fe-lingxi-client.itheima.net/?sdkId=4vfJCk951eHt7hSWCbus&device=h5'

@Entry
@Component
struct CustomerServicePage {
  controller: web_webview.WebviewController = new web_webview.WebviewController()

  build() {
    Column() {
      TitleBar({
        title: '在线客服',
        showBack: true,
        onBack: () => router.back()
      })
      Column() {
        // 使用Web组件加载客服Url
        Web(
          {
            src: SERVICE_URL,
            controller: this.controller
          }
        )
      }
      .layoutWeight(1)
    }
    .height('100%')
    .width('100%')
  }
}