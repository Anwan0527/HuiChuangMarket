import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'

//实例化
const httpInstance = axios.create({
  baseURL: 'https://meikou-api.itheima.net/',
  timeout: 5000
})
//拦截器
//token
httpInstance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  return config
}, (error: AxiosError) => {
  return Promise.reject(error)
})

//相应拦截器
httpInstance.interceptors.response.use((response: AxiosResponse) => {
  return response
}, (error: AxiosError) => {
  return Promise.reject(error)
})

// 1. 定义一个接口通用的泛型返回类型
interface HttpRes<T> {
  code: string,
  msg: string,
  result: T
}

// 封装fetchData函数
// 1. 参数  2. 核心逻辑  3.返回值
function fetchData<T>(reqConfig: AxiosRequestConfig): Promise<AxiosResponse<HttpRes<T>, null>> {
  // axios实例发送请求
  // 返回promise
  return httpInstance.request<null, AxiosResponse<HttpRes<T>, null>, null>(reqConfig)
}

export { httpInstance, fetchData }