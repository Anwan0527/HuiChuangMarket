import { fetchData } from '@HC/common/src/main/ets/utils/http';

export interface BannerItemType {
  hrefUrl: string;
  id: string;
  imgUrl: string;
  type: string;
}


// 封装接口请求
export const getBannerListAPI = () => {
  return fetchData<BannerItemType[]>({
    url: '/home/banner',
    method: 'GET'
  })
}