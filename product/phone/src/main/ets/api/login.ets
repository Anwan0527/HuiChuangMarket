import { fetchData, UserType } from '@CH/common'

// 详情类型和接口
export interface LoginReqDataType {
  account: string
  password: string
}



export const loginAPI = (data: LoginReqDataType) => {
  return fetchData<UserType>({
    url: '/login',
    method: 'POST',
    data
  })
}