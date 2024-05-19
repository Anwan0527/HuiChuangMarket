import { promptAction } from '@kit.ArkUI'
import { GridRowList } from './GridRowList'

interface TabItem {
  title: string,
  id: number
}

@Component
export struct MyTabs {
  @Prop activeBgColor: string = '#000'
  @Prop activeFontColor: string = '#fff'
  @Prop list: TabItem[] = []
  @State activeTab: TabItem = {
    id: 0,
    title: ''
  }
  onChange: (tab: TabItem) => void = () => {
  }

  build() {
    Column() {
      ForEach(this.list, (item: TabItem, index) => {
        Text(item.title)
          .fontColor(this.activeTab.id === item.id ? this.activeFontColor : "#000")
          .onClick(() => {
            this.activeTab = item
            this.onChange(item)
          })
          .backgroundColor(this.activeTab.id === item.id ? this.activeBgColor : "#fff")
      })
    }

  }
}

/*
MyTabs({
  list: [{title:'tab1', id:1}, { title:'tab1', id:1 }],
  onChange: (tab)=>{ console.log(tab.id)},
  activeBgColor: '#000',
  activeFontColor: '#fff'
})*/