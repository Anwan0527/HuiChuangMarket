import { fetchData } from '@CH/common'

interface ReqData {
  token: string, // 华为push token
  deviceId: string // 设备id
}

export const pushAPI = (data: ReqData) => {
  return fetchData<null>({
    url: '/user-member-huawei/saveOrUpdate',
    method: 'POST',
    data
  })
}