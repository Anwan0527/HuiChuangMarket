import { AudioManager, SpeechManager } from '@CH/common'
import { promptAction, router } from '@kit.ArkUI'

type PressState = 1 | 2 | 3

function formatPressState(pressState: PressState): string {
  const Map: Record<PressState, string> = {
    1: '长按语音搜索',
    2: '识别中，请讲话...',
    3: '转文字中...',
  }
  return Map[pressState]
}

@Entry
@Component
struct SearchPage {
  @State pressState: PressState = 1
  @State Keyword: string = ''
  audioManager: AudioManager = new AudioManager()
  speechManager: SpeechManager = new SpeechManager()

  aboutToAppear(): void {
    // 请求录音权限
    this.audioManager.requestPermission()
  }

  build() {
    Column() {
      Row() {
        //<
        Image($r('app.media.arrow_left'))
          .margin({
            left: 17
          })
          .width(24)
          .onClick(() => {
            router.back()
          })

        Row() {
          //搜索
          TextInput({ placeholder: '搜索', text: $$this.Keyword, })
            .backgroundColor(Color.White)
            .height(40)
            .layoutWeight(1)
            .fontColor('#A6A3AD')
            .onSubmit(() => {
              router.pushUrl({
                url: 'pages/SearchResultPage',
                params: {
                  keyword: this.Keyword
                }
              })
            })
          //button
          Button("搜索")
            .onClick(() => {
              router.pushUrl({
                url: 'pages/SearchResultPage',
                params: {
                  keyword: this.Keyword
                }

              })
              // promptAction.showToast({
              //   message: JSON.stringify(this.Keyword)
              // })
            })
            .fontSize(12)
            .height(23)
            .margin({
              right: 7
            })
            .linearGradient({
              angle: 135,
              colors: [
                ['#FD3F8F', 0],
                ['#FF773C', 1]
              ]
            })
          //background: var(--Linear, linear-gradient(93deg, #FD3F8F 0%, #FF773C 100%));
        }
        .borderRadius(20)
        .margin({
          left: 17,
          right: 17
        })
        .backgroundColor(Color.White)
        .width("100%")
        .layoutWeight(1)
      }
      .backgroundColor('#f2e7dc')
      .width("100%")
      .height(56)

      // 语音搜索区域
      Column() {
        Column() {
          Row() {
            Image($r("app.media.ic_public_input_voice"))
              .width(24)
              .fillColor('#fff')
            Text(formatPressState(this.pressState)).fontColor('#fff').fontSize(14)
          }
          .borderRadius(22)
          .width(156)
          .justifyContent(FlexAlign.Center)
          .height(44)
          .linearGradient({
            angle: 135,
            colors: [
              ['#FD3F8F', 0.0],
              ['#FF773C', 1.0]
            ],
            direction: GradientDirection.Left
          })
          .gesture(
            LongPressGesture({ repeat: false })
              .onAction((event: GestureEvent | undefined) => {
                // 开始录音
                this.pressState = 2
                this.audioManager.start()
              })
              .onActionEnd(async () => {
                this.pressState = 3
                // 录音结束
                const filePath = await this.audioManager.stop()
                // 开始识别
                if (filePath) {
                  this.speechManager.start(filePath, (res) => {
                    // console.log(JSON.stringify(res))
                    this.Keyword = res.result
                    this.pressState = 1
                  })
                }
              })
          )
        }
        .width('100%')
        .height('100%')
        .padding({ bottom: 16 })
        .justifyContent(FlexAlign.Center)
        .backgroundImage($r("app.media.ic_public_voice_bg"))
        .backgroundImageSize({ width: '100%', height: '100%' })
      }
      .width('100%')
      .layoutWeight(1)
    }
  }
}