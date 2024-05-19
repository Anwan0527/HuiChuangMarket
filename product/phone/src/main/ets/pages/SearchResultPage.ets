import { GoodsItemType, GridRowList, TitleBar } from '@CH/common/Index'
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
      TitleBar({
        title: this.keyword,
        onBack: () => {
          router.back()
        },
        showBack: true
      })
      Scroll() {
        GridRowList({
          list: this.SearchList
        })
      }
    }
  }
}