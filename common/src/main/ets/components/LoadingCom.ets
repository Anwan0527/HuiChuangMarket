@Preview
@Component
export struct LoadingCom {
  // loading 图片列表
  loadingList: Resource[] = [
    $r('app.media.loading_01'),
    $r('app.media.loading_02'),
    $r('app.media.loading_03'),
    $r('app.media.loading_04'),
  ]
  @Prop isLoading: boolean = true
  @BuilderParam MainContent: () => void = this.defaultSolt
  time: number | null = null //倒计时
  @State actIndex: number = 0
  Loading = () => {
    this.time = setInterval(() => {
      //动画索引
      this.actIndex++
      if (this.actIndex === 4) {
        this.actIndex = 0
      }
    }, 1000)
  }

  @Builder
  defaultSolt() {
    Column() {
      Text('传入主题内容')
    }
  }

  aboutToAppear(): void {
    this.Loading()
  }

  aboutToDisappear(): void {
    this.time && clearInterval(this.time) //清除
  }

  build() {
    if (this.isLoading) {
      Column() {
        //Meiko 图片
        Image(this.loadingList[this.actIndex]).width(60)
      }
    } else {
      //真实内容
      this.MainContent()
    }

  }
}