import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // hilog:日志模块
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    /*
     * Create状态为在应用加载过程中，UIAbility实例创建完成时触发，系统会调用onCreate()回调。
     * 可以在该回调中进行页面初始化操作，例如变量定义资源加载等，用于后续的UI展示。
     * 这里有2个参数,want和launchParam
     * want：Want是对象间信息传递的载体，可以用于应用组件间的信息传递。
     * launchParam：启动参数，用来判断是什么方式启动的
     * */
    // 页面初始化...
  }

  onDestroy(): void {
    // hilog：日志模块
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
    /*
     * Destroy状态在UIAbility实例销毁时触发。可以在onDestroy()回调中进行系统资源的释放、数据的保存等操作。
     * 例如调用terminateSelf()方法停止当前UIAbility实例，从而完成UIAbility实例的销毁；
     * 或者用户使用最近任务列表关闭该UIAbility实例，完成UIAbility的销毁。
     * */
    // 系统资源的释放、数据的保存等
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    /*
     * windowStage：窗口管理器。管理各个基本窗口单元，即Window实例。
     * 可以使用windowStage.on来订阅窗口的状态事件（获焦/失焦、可见/不可见）
     * */
    /*try {
      windowStage.on('windowStageEvent', (data) => {
        let stageEventType: window.WindowStageEventType = data;
        switch (stageEventType) {
          case window.WindowStageEventType.SHOWN: // 切到前台
            console.info('windowStage foreground.');
            break;
          case window.WindowStageEventType.ACTIVE: // 获焦状态
            console.info('windowStage active.');
            break;
          case window.WindowStageEventType.INACTIVE: // 失焦状态
            console.info('windowStage inactive.');
            break;
          case window.WindowStageEventType.HIDDEN: // 切到后台
            console.info('windowStage background.');
            break;
          default:
            break;
        }
      });
    } catch (exception) {
      console.error('Failed to enable the listener for window stage event changes. Cause:' +
      JSON.stringify(exception));
    }*/

    /*
     * 使用windowStage.loadContent来设置UI加载的第一个页面
     * */
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      // 注意，这里的时候，页面的UI资源已经加载完成，可以执行一些Ark框架中的一些核心方法
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    /*
     * 在UIAbility实例销毁之前，则会先进入onWindowStageDestroy()回调。
     * 可以在该回调中释放UI资源。例如在onWindowStageDestroy()中注销获焦/失焦等WindowStage事件。
     * */
    // 释放UI资源
    // 例如在onWindowStageDestroy()中注销获焦/失焦等WindowStage事件
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
    /*
     * onForeground()回调，在UIAbility的UI可见之前，如UIAbility切换至前台时触发。
     * 可以在onForeground()回调中申请系统需要的资源，或者重新申请在onBackground()中释放的资源。
     * */
    // 申请系统需要的资源，或者重新申请在onBackground()中释放的资源
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
    /*
     * onBackground()回调，在UIAbility的UI完全不可见之后，如UIAbility切换至后台时候触发。
     * 可以在onBackground()回调中释放UI不可见时无用的资源，或者在此回调中执行较为耗时的操作，例如状态保存等。
     * */
    // 释放UI不可见时无用的资源，或者在此回调中执行较为耗时的操作
    // 例如状态保存等
  }
}
