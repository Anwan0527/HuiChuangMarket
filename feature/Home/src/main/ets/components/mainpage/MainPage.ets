import { HomeBanner } from '../HomeBanner'
import { HomeCategory } from '../HomeCategory'
import { HomeNew } from '../HomeNew'
import { HomeRecommend } from '../HomeRecommend'

@Entry
@Component
export struct MainPage {
  build() {
    Scroll() {
      Column() {
        HomeBanner()
        HomeCategory()
        HomeNew()
        HomeRecommend()
      }
    }

  }
}