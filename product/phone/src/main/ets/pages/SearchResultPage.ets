import { GoodsItemType, GridRowList } from '@CH/common/Index'
import { router } from '@kit.ArkUI'
import { getSearchListAPI, Item } from '../api/search'

interface RouteParams {
  keyword: string
}

@Entry
@Component
struct SearchResultPage {
  @State keyword: string = ''
  @State SearchList: GoodsItemType[] = []
  GetSearchList = async () => {
    const res = await getSearchListAPI({
      page: 1,
      pageSize: 10,
      keyword: this.keyword
    })
    this.SearchList = res.data.result.pageData.items
  }

  @Builder
  Nav() {
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
      Text(this.keyword)
        .layoutWeight(1)
        .width("100%")
    }
  }

  aboutToAppear() {
    const params = router.getParams() as RouteParams
    if (params) {
      this.keyword = params.keyword
      this.GetSearchList()
    }

    // AlertDialog.show({
    //   message: JSON.stringify(params.keyword)
    // })

  }

  build() {
    Column() {
      this.Nav()
      GridRowList({
        list: this.SearchList
      })
    }

  }
}