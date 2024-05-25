// 解析参数函数
export function parseQueryParams(url: string): Record<string, string> {
  const queryString = url.split('?')[1] // 获取问号后面的查询字符串部分
  const params: Record<string, string> = {}

  if (queryString) {
    const keyValuePairs = queryString.split('&') // 将查询字符串按 & 分割成键值对数组

    keyValuePairs.forEach((pair) => {
      const arr = pair.split('=')
      const key = arr[0] // 将键值对按 = 分割成键和值
      const value = arr[1]
      params[key] = decodeURIComponent(value) // 将值进行 URL 解码并存入 params 对象
    })
  }
  return params
}
