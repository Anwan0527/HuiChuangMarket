import { fetchData } from '@CH/common/src/main/ets/utils/http'

// 2. 定义当前业务接口的具体返回值类型
export interface BannerItem {
  id: string,
  imgUrl: string,
  hrefUrl: string,
  type: string
}

export const getBannerAPI = () => {
  return fetchData<BannerItem[]>({
    url: '/home/banner',
    method: 'GET'
  })
}
