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