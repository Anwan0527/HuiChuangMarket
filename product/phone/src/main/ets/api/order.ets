import { fetchData } from '@CH/common'

export interface Result {
  goods: Good[];
  summary: Summary;
  userAddresses: UserAddress[];
}

export interface Good {
  attrsText: string;
  count: number;
  id: string;
  name: string;
  payPrice: string;
  picture: string;
  price: string;
  skuId: string;
  totalPayPrice: string;
  totalPrice: string;
}

export interface Summary {
  discountPrice: number;
  goodsCount: number;
  postFee: number;
  totalPayPrice: number;
  totalPrice: number;
}

export interface UserAddress {
  address: string;
  addressTags: string;
  cityCode: string;
  contact: string;
  countyCode: string;
  fullLocation: string;
  id: string;
  isDefault: number;
  postalCode: string;
  provinceCode: string;
  receiver: string;
} // 创建订单

interface OrderResultType {
  id: string
}

export interface OrderGood {
  skuId: string
  count: number
}

interface ReqType {
  deliveryTimeType: number
  payType: number
  payChannel: number
  buyerMessage: string
  goods: OrderGood[]
  addressId: string
}

export const createOrderAPI = (data: ReqType) => {
  return fetchData<OrderResultType>({
    url: '/member/order',
    method: 'POST',
    data
  })
}

// 获取订单结算信息
export const getOrderPreAPI = () => {
  return fetchData<Result>({
    url: '/member/order/pre'
  })
}