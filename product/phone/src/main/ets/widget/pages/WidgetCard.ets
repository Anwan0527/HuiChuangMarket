let storageWidgetImageUpdate = new LocalStorage()


@Entry(storageWidgetImageUpdate)
@Component
struct WidgetCard {
  @LocalStorageProp('fileNameList')
  fileNameList: string[] = []

  build() {
    Column() {
      Row() {
        Text('今日推荐')
          .fontColor('#fff')
          .fontSize(16)

        Image($r('app.media.ic_card_refresh'))
          .width(24)
          .onClick(() => {
            postCardAction(this,
              {
                action: 'message',
                abilityName: 'EntryAbility'
              }
            )
          })
      }
      .height(40)
      .width('100%')
      .padding({
        left: 10,
        right: 10
      })
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        ForEach(
          this.fileNameList,
          (url: string) => {
            Row() {
              Image('memory://' + url)
                .borderRadius(12)
                .width(50)
                .aspectRatio(1)
            }
            .backgroundColor('#eee')
            .borderRadius(12)
          }
        )
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .layoutWeight(1)
      .padding({
        left: 20,
        right: 20
      })
      .backgroundColor('#fff')
      .borderRadius({
        topRight: 16,
        topLeft: 16
      })
      .onClick(() => {
        postCardAction(this, {
          action: 'router',
          abilityName: 'EntryAbility',
          params: { targetPage: 'HotRecommendPage' }
        })
      })
    }
    .linearGradient({
      angle: '135',
      colors: [
        ['#FD3F8F', '0%'],
        ['#FF773C', '100%']
      ]
    })
    .height('100%')
  }
}