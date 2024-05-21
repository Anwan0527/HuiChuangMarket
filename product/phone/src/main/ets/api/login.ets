import { fetchData, UserType } from '@CH/common'

// 详情类型和接口
export interface LoginReqDataType {
  account: string
  password: string
}

// 华为登录
interface Data {
  code: string
  clientId: string
  clientSecret: string
}

// 演示使用，实际秘钥应该由后端通过接口返回
export const clientId = '110650049'

export const clientSecret = '25378f785493a6364320c26fab63139e7e30944390ba733c60113938fe9e4c96'

export const huaweiLoginAPI = (code: string) => {
  return fetchData<UserType>({
    url: '/login/huawei',
    method: 'POST',
    data: {
      code: code,
      clientId,
      clientSecret
    }
  })
}

export const loginAPI = (data: LoginReqDataType) => {
  return fetchData<UserType>({
    url: '/login',
    method: 'POST',
    data
  })
}