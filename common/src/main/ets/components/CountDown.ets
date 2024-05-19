// interface CountDownProps {
//   time: number; // 时间，单位为毫秒
//   onFinished: () => void; // 计时结束时的回调函数
//   onTimeChange: (time: number) => void; // 计时变化时的回调函数
// }

@Component
export struct CountDown {
  @Prop time: number = 0
  onTimeChange: (time: number) => void = () => {
  }
  onFinished: () => void = () => {
  }

  build() {

  }
}