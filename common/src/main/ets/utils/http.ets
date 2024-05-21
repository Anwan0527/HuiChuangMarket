import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { Auth } from './Auth'
import { promptAction, router } from '@kit.ArkUI'

// 定义一个自己业务的错误接口类型
interface APIErrorType {
  message: string
  msg: string
  code: string
}

//实例化
const httpInstance = axios.create({
  baseURL: 'https://meikou-api.itheima.net/',
  timeout: 5000
})
//拦截器
//token
httpInstance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  const token = Auth.getUser()?.token
  if (token) {
    config.headers.Authorization = token
  }
  return config
}, (error: AxiosError) => {
  return Promise.reject(error)
})


// 添加响应拦截器
httpInstance.interceptors.response.use((response: AxiosResponse) => {
  // 对响应数据做点什么
  return response
}, (error: AxiosError<APIErrorType>) => {
  // 对响应错误做点什么
  if (error.response) {
    promptAction.showToast({
      message: error.response.data.message,
      duration: 2000
    })

    // token失效跳转到登录页
    if (error.response.status === 401) {
      // 清除本地用户信息
      Auth.delUser()
      // 跳转到登录页
      router.pushUrl({
        url: 'pages/LoginPage'
      })
    }
  }
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