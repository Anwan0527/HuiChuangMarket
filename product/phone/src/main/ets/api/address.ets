import { fetchData } from '@CH/common'

// 获取地址
export interface AddressItemType {
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
}

// 返回参数类型
export interface RequestType {
  address: string;
  contact: string;
  isDefault: number;
  receiver: string;
}

// 新增地址
export const createAddressAPI = (data: RequestType) => {
  return fetchData<null>({
    url: '/member/address',
    method: 'POST',
    data
  })
}

export const getAddressListAPI = () => {
  return fetchData<AddressItemType[]>({
    url: '/member/address'
  })
}

// 设为默认
export const updateAddressAPI = (id: string) => {
  return fetchData<null>({
    url: `/member/address/${id}`,
    method: 'PUT',
    data: {
      isDefault: 0
    }
  })
}

// 删除地址
export const delAddressAPI = (id: string) => {
  return fetchData<null>({
    url: `/member/address/${id}`,
    method: 'DELETE'
  })
}