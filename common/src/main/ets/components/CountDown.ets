import dayjs from 'dayjs'

@Component
export struct CountDownCom {
  @Prop
  initialTime: number = 0
  @State
  time: number = this.initialTime
  timer: number | null = null
  // 格式化之后的数据
  start = () => {
    this.timer = setInterval(() => {
      if (this.time === 0) {
        return
      }
      this.time--
    }, 1000)
  }
  formatTime = (time: number) => {
    if (time === 0 || time === -1) {
      return '订单已超时'
    }
    return dayjs.unix(time).format('mm分ss秒')
  }

  aboutToAppear() {
    if (this.initialTime > 0) {
      this.start()
    }
  }

  aboutToDisappear() {
    this.timer && clearInterval(this.timer)
  }

  build() {
    Row() {
      Row() {
        Text('待付款').fontSize(10).fontColor('#fff')
      }
      .padding({
        left: 10,
        right: 10,
        bottom: 4,
        top: 4
      })
      .linearGradient({
        angle: 135,
        colors: [
          ['#FD3F8F', 0],
          ['#FF773C', 1]
        ]
      })
      .borderRadius({
        topLeft: 10,
        bottomLeft: 10,
        topRight: 0,
        bottomRight: 10
      })
      .visibility(this.time > 0 ? Visibility.Visible : Visibility.None)

      Row() {
        Text(this.formatTime(this.time)).fontSize(10).fontColor('#FF773C')
      }
      .padding({
        left: 10,
        right: 10,
        bottom: 4,
        top: 4
      })
    }
    .backgroundColor('#FFDEE2')
    .borderRadius(10)
  }
}

@Entry
@Component
struct PageCom {
  build() {
    Column() {
      CountDownCom({
        initialTime: 5
      })

      CountDownCom({
        initialTime: 0
      })
    }
  }
}