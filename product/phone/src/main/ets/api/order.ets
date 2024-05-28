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

export interface GetOrderReqType {
  page: number
  pageSize: number
  orderState: 0 | 1 | 2 | 3 | 4 | 4 | 5 | 6
}

export interface OrderResult {
  counts: number;
  items: OrderItem[];
  page: number;
  pages: number;
  pageSize: number;
}

export interface OrderItem {
  countdown: number;
  createTime: string;
  id: string;
  orderState: number;
  payChannel: number;
  payLatestTime: string;
  payMoney: number | number;
  payType: number;
  postFee: number;
  skus: Skus[];
  totalMoney: number | number;
  totalNum: number;
}

export interface Skus {
  attrsText: string;
  curPrice: number | number;
  id: string;
  image: string;
  name: string;
  properties: Property[];
  quantity: number;
  realPay: number | number;
  spuId: string;
  totalMoney: null;
}

export interface Property {
  propertyMainName: string;
  propertyValueName: string;
}

export const getOrderListAPI = (params: GetOrderReqType) => {
  return fetchData<OrderResult>({
    url: '/member/order',
    params
  })
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