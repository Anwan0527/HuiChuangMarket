import { fetchData } from '@CH/common'

// 购物车子项类型
export interface Result {
  attrsText: string;
  count: number;
  discount: null;
  id: string;
  isCollect: boolean;
  isEffective: boolean;
  name: string;
  nowOriginalPrice: string;
  nowPrice: string;
  picture: string;
  postFee: number;
  price: string;
  selected: boolean;
  skuId: string;
  specs: string[];
  stock: number;
}

// 获取购物车列表
export const getCartListAPI = () => {
  return fetchData<Result[]>({
    url: '/member/cart'
  })
}

//单选
export const changeCartSelectedAPI = (skuId: string, selected: boolean, count: number) => {
  return fetchData<null>({
    url: `/member/cart/${skuId}`,
    method: 'PUT',
    data: {
      selected,
      count
    }
  })
}

//全选
export const changeAllCartSelectedAPI = (selected: boolean) => {
  return fetchData<null>({
    url: '/member/cart/selected',
    method: 'PUT',
    data: {
      selected
    }
  })
}


// 删除
export const delCartAPI = (ids: string[]) => {
  return fetchData<null>({
    url: '/member/cart',
    method: 'DELETE',
    data: {
      ids
    }
  })
}