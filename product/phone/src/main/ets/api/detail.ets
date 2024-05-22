import { fetchData } from '@CH/common'

export interface Result {
  brand: Brand;
  categories: Category[];
  collectCount: number;
  commentCount: number;
  desc: string;
  details: Details;
  discount: number;
  evaluationInfo: null;
  hotByDay: HotByDay[];
  id: string;
  inventory: number;
  isCollect: null;
  isPreSale: boolean;
  mainPictures: string[];
  mainVideos: string[];
  name: string;
  oldPrice: string;
  price: string;
  recommends: null;
  salesCount: number;
  similarProducts: SimilarProduct[];
  skus: Skus[];
  specs: ResultSpec[];
  spuCode: string;
  userAddresses: null;
  videoScale: number;
}

export interface Brand {
  desc: null;
  id: string;
  logo: string;
  name: string;
  nameEn: string;
  picture: string;
  place: null;
  type: null;
}

export interface Category {
  id: string;
  layer: number;
  name: string;
  parent: null | Parent;
}

export interface Parent {
  id: string;
  layer: number;
  name: string;
  parent: null;
}

export interface Details {
  pictures: string[];
  properties: Property[];
}

export interface Property {
  name?: string;
  value?: string;
}

export interface HotByDay {
  desc: string;
  id: string;
  name: string;
  orderNum: number;
  picture: string;
  price: string;
}

export interface SimilarProduct {
  desc: string;
  id: string;
  name: string;
  orderNum: number;
  picture: string;
  price: string;
}

export interface Skus {
  id: string;
  inventory: number;
  oldPrice: string;
  picture: string;
  price: string;
  skuCode: string;
  specs: SkusSpec[];
}

export interface SkusSpec {
  name: string;
  valueName: string;
}

export interface ResultSpec {
  id: string;
  name: string;
  values: Value[];
}

export interface Value {
  desc: string;
  name: string;
  picture: string;
}

export const getGoodsDetail = (id: string = '1750713979560263686') => {
  return fetchData<Result>({
    url: '/goods',
    params: {
      id
    }
  })
}


export const addCartAPI = (skuId: string, count: number) => {
  return fetchData<null>({
    url: '/member/cart',
    method: 'POST',
    data: {
      skuId,
      count
    }
  })
}