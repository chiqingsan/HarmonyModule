import taskPool from '@ohos.taskpool';

// 该方法在子线程中执行
@Concurrent
function doInBackground(params: string) {
  setInterval(() => {
    console.log("doInBackground: " + params);

  }, 1000)
}

@Entry
@Component
struct TaskPool {
  private backgroundTask: taskPool.Task | null = null

  build() {
    Column({ space: 10 }) {
      Button("创建Task")
        .onClick(() => {
          this.createTask();
        })

      Button("执行Task")
        .onClick(() => {
          this.executeTask();
        })

      Button("查询Task")
        .onClick(() => {
          this.isCanceled()
        })

      Button("取消Task")
        .onClick(() => {
          this.cancelTask();
        })
    }
    .width("100%")
    .height("100%")
    .padding(10)
  }

  createTask() {
    this.backgroundTask = new taskPool.Task(doInBackground, "background params");
  }

  executeTask() {
    if (this.backgroundTask) {
      taskPool.execute(this.backgroundTask);
      // taskPool.execute(doInBackground, "运行函数");
    }
  }

  isCanceled() {
    console.log(`${taskPool.isConcurrent(doInBackground)}`)
  }

  // 报错的...找不到解决办法
  cancelTask() {
    if (this.backgroundTask) {
      try {
        taskPool.cancel(this.backgroundTask);
      } catch (e) {
        console.log("taskPool_e:", JSON.stringify(e))
      }
    }
  }
}