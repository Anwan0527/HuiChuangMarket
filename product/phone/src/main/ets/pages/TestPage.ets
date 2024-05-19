import { CountDown, LoadingCom, MyTabs } from '@CH/common/Index'
import { mediaquery, promptAction } from '@kit.ArkUI'

export interface OrientationState {
  isLand: boolean
}

@Component
struct CheckLandscape {
  listenerScreen = mediaquery.matchMediaSync('(orientation: landscape)')
  @State
  orientationState: OrientationState = {
    isLand: false
  }
  @BuilderParam Solt: (orientationState: OrientationState) => void = this.defaultBuilder

  @Builder
  defaultBuilder() {
  }

  aboutToAppear() {
    this.listenerScreen.on('change', (mediaQueryResult) => {
      this.orientationState.isLand = mediaQueryResult.matches
    })
  }

  build() {
    this.Solt(this.orientationState)
  }
}

@Entry
@Component
struct TestPage {
  build() {
    Column() {
      MyTabs({
        list: [{ title: 'tab1', id: 1 }, { title: 'tab2', id: 2 }],
        onChange: (tab) => {
          promptAction.showToast({
            message: JSON.stringify(tab.id)
          })
        },
        activeBgColor: '#000',
        activeFontColor: '#fff'
      })
    }
  }
}