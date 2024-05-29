import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { Log } from '@abner/log';
import { Auth } from '@CH/common/Index';

export default class EntryAbility extends UIAbility {
  // 存放拉起页地址
  private selectPage: string = ''
  private currentWindowStage: window.WindowStage | null = null

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Log.init({
      tag: "HC",
      domain: 0x0000,
      close: false,
      isHilog: true,
      showLogLocation: true,
      logSize: 800
    })
    if (want.parameters !== undefined) {
      let params: Record<string, string> = JSON.parse(JSON.stringify(want.parameters))
      this.selectPage = params.targetPage
      console.log('当前selectPage:', this.selectPage)
    }
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 解析参数 把参数中的targetPage存入selectedPage中
    if (want.parameters !== undefined) {
      // 中间官方做了一层深度克隆
      const params: Record<string, string> = JSON.parse(JSON.stringify(want.parameters))
      this.selectPage = params.targetPage
      // 手动触发onWindowStateCreate
      if (this.currentWindowStage !== null) {
        this.onWindowStageCreate(this.currentWindowStage)
      }
    }
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    //是否有落地页情况下的打开地址
    const targetPage = this.selectPage ? `pages/${this.selectPage}` : 'pages/Index'
    console.log('当前targetPage:', targetPage)
    //首次打开
    if (this.currentWindowStage === null) {
      this.currentWindowStage = windowStage
    }

    windowStage.loadContent(targetPage, (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.Data: %{public}s', JSON.stringify(data) ?? '');
      Auth.initLocalUser()
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
