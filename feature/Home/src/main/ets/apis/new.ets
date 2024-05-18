import { fetchData } from '@HC/common/src/main/ets/utils/http';

export interface NewGoodsItemType {
  desc: string;
  id: string;
  name: string;
  orderNum: number;
  picture: string;
  price: string;
}

export const getNewGoodsListAPI = () => {
  return fetchData<NewGoodsItemType[]>({
    url: '/home/new'
  })
}