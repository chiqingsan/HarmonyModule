import { worker } from '@kit.ArkTS';


const TAG = "WORKER_MAIN_THREAD";
const URL = "entry/ets/workers/Worker.ets";

@Entry
@Component
struct Workers {
  workerInstance: worker.ThreadWorker | null = null

  initWorker() {
    this.workerInstance = new worker.ThreadWorker(URL, {
      name: "WORKER_THREAD"
    })
  }

  monitorMessage() {
    try {
      this.workerInstance!.onmessage = (data) => {
        console.log(`${TAG}, workerInstance.onMessage: ` + data);
      }
    } catch (e) {
      console.error(JSON.stringify(e))
    }
  }

  sendMessage() {
    try {
      this.workerInstance!.postMessage("Hello, Worker, I'm main thread");
    } catch (e) {
      console.error(JSON.stringify(e))
    }
  }

  destroyWorker() {
    try {
      this.workerInstance!.terminate();
    } catch (e) {
      console.error(JSON.stringify(e))
    }
  }

  build() {
    Column({ space: 8 }) {
      Button("初始化Worker")
        .height(60)
        .fontSize(20)
        .onClick(() => {
          this.initWorker();
        })

      Button("监听Worker的消息")
        .height(60)
        .fontSize(20)
        .onClick(() => {
          this.monitorMessage();
        })

      Button("给Worker发消息")
        .height(60)
        .fontSize(20)
        .onClick(() => {
          this.sendMessage();
        })

      Button("销毁 Worker")
        .height(60)
        .fontSize(20)
        .onClick(() => {
          this.destroyWorker();
        })

    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}