import { GridRowList, GoodsItemType } from '@HC/common/Index'
import { Log } from '@abner/log/src/main/ets/Log'
import { getRecommendAPI } from '../apis/recommendList'


@Entry
@Component
export struct HomeRecommend {
  @State
  recommendList: GoodsItemType[] = []
  getRecommend = async () => {
    try {
      const res = await getRecommendAPI()
      this.recommendList = res.data.result
    } catch (e) {
      Log.error(e)
    }
  }

  aboutToAppear() {
    this.getRecommend()
  }

  build() {
    Column() {
      GridRowList({
        list: this.recommendList
      })
    }
  }
}