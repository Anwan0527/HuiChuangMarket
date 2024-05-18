import { promptAction, router } from '@kit.ArkUI'

@Entry
@Component
struct SearchPage {
  @State Keyword: string = ''

  build() {
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
  }
}