import { fetchData } from '@HC/common/src/main/ets/utils/http'

export interface CategoryType {
  children: Child[]
  goods: Good[]
  id: string
  name: string
  picture: string
}

export interface Child {
  children: null
  goods: null
  id: string
  name: string
  picture: string
}

export interface Good {
  desc: string
  id: string
  name: string
  orderNum: null
  picture: string
  price: null | string
}

export const getCategoryListAPI = () => {
  return fetchData<CategoryType[]>({
    url: '/home/category/head'
  })
}