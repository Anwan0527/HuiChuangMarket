import { fetchData } from '@HC/common/src/main/ets/utils/http';
import { GoodsItemType } from '@HC/common/Index';


export const getRecommendAPI = () => {
  return fetchData<GoodsItemType[]>({
    url: '/home/recommend'
  })
}