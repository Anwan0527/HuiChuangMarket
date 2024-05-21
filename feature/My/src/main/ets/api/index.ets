// 猜你喜欢接口
import { fetchData, GoodsItemType } from '@CH/common/Index';

export interface Result {
  counts: number;
  items: GoodsItemType[];
  page: number;
  pages: number;
  pageSize: number;
}

export interface Item {
  desc: string;
  id: string;
  name: string;
  orderNum: number;
  picture: string;
  price: string;
}

export const getLikeListAPI = () => {
  return fetchData<Result>({
    url: '/home/goods/guessLike',
    params: {
      limit: 10
    }
  })
}