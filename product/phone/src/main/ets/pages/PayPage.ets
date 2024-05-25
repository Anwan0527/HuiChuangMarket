import { parseQueryParams, TitleBar } from '@CH/common/Index'
import web_webview from '@ohos.web.webview'
import { router } from '@kit.ArkUI'

const payUrl = 'https://meikou-api.itheima.net/'

interface RouterParams {
  orderId: string
}

@Entry
@Component
struct PayPage {
  // 订单id
  orderId: string = ''
  webviewController: web_webview.WebviewController = new web_webview.WebviewController()
  responseResource: WebResourceResponse = new WebResourceResponse()

  aboutToAppear(): void {
    const params: RouterParams = router.getParams() as RouterParams
    this.orderId = params.orderId
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        // 如果有订单id
        if (this.orderId) {
          Web({
            src: `${payUrl}/pay/wap/aliPay?orderId=${this.orderId}`,
            controller: this.webviewController
          })
            .onInterceptRequest((event) => {
              if (event) {
                if (event.request.getRequestUrl().indexOf('/pay/redirect') > -1) {
                  const redirectUrl = event.request.getRequestUrl()
                  const params = parseQueryParams(redirectUrl)
                  router.pushUrl({
                    url: 'pages/AliPayResultPage',
                    params
                  })
                }
                return null
              }
              this.responseResource.setResponseEncoding('utf-8')
              this.responseResource.setResponseMimeType('text/html')
              this.responseResource.setResponseCode(200)
              this.responseResource.setReasonMessage('OK')
              return this.responseResource
            })
        }
      }
      .height('100%')

      // title bar
      TitleBar({
        title: '支付中',
        showBack: true,
        onBack: () => {
          router.back()
        }
      })
    }
    .height('100%')
  }
}