import { Log } from '@abner/log'
import { CategoryType, getCategoryListAPI } from '../apis/category'

@Component
export struct HomeCategory {
  // 获取分类
  @State
  categoryList: CategoryType[] = []
  // 背景颜色数组
  @State bgColorList: string[] = [
    '#faf7f0',
    '#f9ecf1',
    '#dedfe7',
    '#f0f9f9',
    '#faf7f0',
    '#faf7f0',
    '#f9ecf1',
    '#dedfe7',
  ]
  GetCategoryList = async () => {
    try {
      const res = await getCategoryListAPI()
      this.categoryList = res.data.result
    } catch (e) {
      Log.error(e)
    }
  }

  aboutToAppear(): void {
    this.GetCategoryList()
  }

  build() {
    Row() {
      Scroll() {
        Row({ space: 20 }) {
          ForEach(
            this.categoryList,
            (item: CategoryType, index: number) => {
              Column() {
                Image(item.picture).width(42)
                Text(item.name)
                  .fontColor('#CC191919')
                  .fontSize(10)
              }
              .width(60)
              .aspectRatio(6 / 8)
              .backgroundColor(this.bgColorList[index])
              .borderRadius(30)
              .justifyContent(FlexAlign.Center)
            }
          )
        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
    }
    .padding(8)
  }
}