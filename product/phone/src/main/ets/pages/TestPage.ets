import { reminderAgentManager } from '@kit.BackgroundTasksKit'
import { notificationManager } from '@kit.NotificationKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { wantAgent, WantAgent } from '@kit.AbilityKit'

@Entry
@Component
struct test {
  build() {
    Column() {
      Button('权限').onClick(() => {
        notificationManager.requestEnableNotification()
      })
      Button('通知')
        .onClick(() => {
          let wantAgentObj: WantAgent; // 用于保存创建成功的wantAgent对象，后续使用其完成触发的动作。

          // 通过WantAgentInfo的operationType设置动作类型
          let wantAgentInfo: wantAgent.WantAgentInfo = {
            wants: [
              {
                deviceId: '',
                bundleName: 'com.lanyin.huichuang',
                abilityName: 'EntryAbility',
                action: '',
                entities: [],
                uri: 'pages/Index',
                parameters: {}
              }
            ],
            operationType: wantAgent.OperationType.START_ABILITY,
            requestCode: 0,
            wantAgentFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG]
          };
          let targetReminderAgent: reminderAgentManager.ReminderRequestAlarm = {
            reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM, // 提醒类型为闹钟类型
            hour: 19, // 指明提醒的目标时刻
            minute: 25, // 指明提醒的目标分钟
            daysOfWeek: [4], // 指明每周哪几天需要重复提醒
            actionButton: [// 设置弹出的提醒通知信息上显示的按钮类型和标题
              {
                title: 'close',
                type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
              },
              {
                title: 'snooze',
                type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_SNOOZE
              },
            ],
            wantAgent: {
              // 点击提醒通知后跳转的目标UIAbility信息
              pkgName: 'com.lanyin.huichuang',
              abilityName: 'EntryAbility',
            },
            maxScreenWantAgent: {
              // 全屏显示提醒到达时自动拉起的目标UIAbility信息
              pkgName: 'com.lanyin.huichuang',
              abilityName: 'EntryAbility'
            },
            ringDuration: 5, // 指明响铃时长（单位：秒）
            snoozeTimes: 2, // 指明延迟提醒次数
            timeInterval: 5, // 执行延迟提醒间隔（单位：秒）
            title: 'this is title', // 指明提醒标题
            content: 'this is content', // 指明提醒内容
            expiredContent: 'this reminder has expired', // 指明提醒过期后需要显示的内容
            snoozeContent: 'remind later', // 指明延迟提醒时需要显示的内容
            notificationId: 99, // 指明提醒使用的通知的ID号，相同ID号的提醒会覆盖
            slotType: notificationManager.SlotType.SOCIAL_COMMUNICATION // 指明提醒的Slot类型
          }
          reminderAgentManager.publishReminder(targetReminderAgent).then((res: number) => {
            console.info('Succeeded in publishing reminder. ');
            let reminderId: number = res; // 发布的提醒ID
          }).catch((err: BusinessError) => {
            console.error(`Failed to publish reminder. Code: ${err.code}, message: ${err.message}`);
          })
        })
    }

  }
}