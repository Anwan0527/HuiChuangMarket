import { mediaquery } from '@kit.ArkUI'

export interface OrientationState {
  isLand: boolean
}

@Component
export struct CheckLandscape {
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
      // AlertDialog.show({
      //   message: JSON.stringify(mediaQueryResult.matches)
      // })
    })
  }

  build() {
    this.Solt(this.orientationState)
  }
}