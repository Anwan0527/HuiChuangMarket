import { mediaquery } from '@kit.ArkUI'

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
  @Builder
  RenderText(state: OrientationState) {
    Text(state.isLand.toString())
  }

  build() {
    Row() {
      CheckLandscape({
        Solt: (State) => {
          this.RenderText(State)
        }
      })
    }
  }
}