import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
//实例化
const httpInstance=axios.create({
  baseURL:'https://meikou-api.itheima.net/',
  timeout:5000
})
//拦截器
//token
httpInstance.interceptors.request.use((config:InternalAxiosRequestConfig)=>{
  return config
},(error:AxiosError)=>{
  return Promise.reject(error)
})

//相应拦截器
httpInstance.interceptors.response.use((response:AxiosResponse)=>{
  return response
},(error:AxiosError)=>{
  return Promise.reject(error)
})