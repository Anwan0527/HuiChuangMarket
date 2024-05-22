import { LogOptions } from '@abner/log'

interface Item {
  name: string
  age: number
}

const personList: Item[] = [
  { name: '张三', age: 20 },
  { name: '李四', age: 30 },
  { name: '王五', age: 40 },
  { name: '小李', age: 50 },
  { name: '小王', age: 60 },
]

//要求实现一个函数可以过滤得到age大于30的所有项
function getAge30(list: Item[]) {
  // 实现逻辑
  // 方法1:return list.filter(item => item.age > 30)
  const newlist: Item[] = []
  for (let i = 0; i < list.length; i++) {
    if (list[i].age > 30) {
      newlist.push(list[i])
    }
  }
  return newlist
}

//要求实现一个函数，可以计算出来所有人的年龄之和
function calcAge(list: Item[]) {
  // 实现逻辑
  // 方法1:return list.reduce((sum, item) => sum + item.age, 0)
  let sum: number = 0
  for (let i = 0; i < list.length; i++) {
    sum = sum + list[i].age
  }
  return sum
}

type trigFunc = (x: number) => number

function myMap(list: number[], f: trigFunc) {
  // 方法1:return list.map(item => f(item))
  let newList: number[] = []
  for (let i = 0; i < list.length; i++) {
    newList.push(f(list[i]))
  }
  return newList
}

function myMap2<T, U>(list: T[], f: (item: T) => U): U[] {
  return list.map(f);

}

const newList = getAge30(personList)
// console.log("", JSON.stringify(newList))
const allAge = calcAge(personList)

// console.log("", JSON.stringify(allAge)) // 200

const newList2 = myMap([1, 2, 3], (item) => {
  return item * 2
}) // newList = [2, 4, 6]

// console.log("", JSON.stringify(newList2))

// // 支持number
const newList3 = myMap2([1, 2, 3], (item) => {
  return item * 2
})
console.log("", JSON.stringify(newList3))
// 支持string
const newList4 = myMap2(['1', '2', '3'], (item) => {
  return item + '4'
})
console.log("", JSON.stringify(newList4))

// newList = ['14','24', '34']
@Entry
@Component
struct TestPage {
  mList: Array<string> = [
    "YYL", "TWT", "TWT", "TWT", "TWT",
    "YYL", "TWT", "TWT", "TWT", "TWT",
    "YYL", "TWT", "TWT", "TWT", "TWT",
    "YYL", "TWT", "TWT", "TWT", "TWT",
    "YYL", "TWT", "TWT", "TWT", "YYL"
  ]

  build() {
    Column() {
      List() {
        ForEach(this.mList, (text: string) => {
          ListItem() {
            Text(text)
              .fontSize(50)
          }
        })
      }
      .width("100%")
      .height("100%") //你没有的
    }
    .width("100%")
    .height("100%")
  }
}