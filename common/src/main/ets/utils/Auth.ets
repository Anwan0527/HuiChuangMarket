// 用户信息类型
export interface UserType {
  token: string
  nickname: string
  avatar: string
  account: string
  id: string
}

export const USER_KEY = 'userInfo'

export class Auth {
  // 存数据
  static setUser(user: UserType) {
    AppStorage.setOrCreate(USER_KEY, user)
  }

  // 取数据
  static getUser(): UserType | undefined {
    return AppStorage.get<UserType>(USER_KEY)
  }

  // 删数据
  static delUser() {
    AppStorage.setOrCreate(USER_KEY, {})
  }
}