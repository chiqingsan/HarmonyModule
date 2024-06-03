import { media } from '@kit.MediaKit';

class AVPlayerManager {
  private avPlayer: media.AVPlayer | null = null
  private loop: boolean = false

  async getAVPlayerInstance() {
    // 如果已存在，直接返回
    if (this.avPlayer !== null) {
      return this.avPlayer
    }
    // 初始化播放器
    const player = await media.createAVPlayer()
    player.on('stateChange', (state) => {
      switch (state) {
        case 'idle':
        // 当AVPlayer初始化后默认进入改状态,成功调用reset接口后也会进入该状态
        // player.fdSrc设置后,player会进入initialized状态,再次触发stateChange状态,进入该回调函数
          break;
        case 'initialized':
        // player设置player.fdSrc播放源后触发该状态上报
        // 将player设置为prepare(准备播放)状态,触发stateChange状态,再次进入回调函数
          player.prepare();
          break;
        case 'prepared':
        // prepare调用成功后上报该状态机
        // 调用播放接口开始播放
          player.play();
          break;
        case 'playing':
        // play成功调用后触发该状态机上报
          break;
        case 'paused':
        // pause成功调用后触发该状态机上报
          break;
        case 'completed':
        // 播放结束后触发该状态机上报
          if (this.loop) {
            player.play()
          } else {
            // 重置播放状态
            player.reset()
          }
          break;
        case 'stopped':
        // stop接口成功调用后触发该状态机上报
          player.reset();
        // 调用reset接口初始化avplayer状态
          break;
        default:
          console.info('AVPlayer当前状态未知');
          break;
      }
    })
    this.avPlayer = player
    return this.avPlayer
  }

  // 加载 src/main/resources/rawfile 的文件
  async playByRawSrc(rawFdPath: string, loop: boolean = false) {
    // 设置是否循环播放,默认不循环
    this.loop = loop
    // 拿到avPlayer的实例
    const player = await this.getAVPlayerInstance()
    // 如果AVPlayer的状态不是idle,则重置AVPlayer为idle,方便后面设置新的播放源
    if (player.state !== "idle") { // 先释放原来的资源
      // 只能在initialized/prepared/playing/paused/completed/stopped/error状态调用
      await player.reset()
    }
    // 获取文件信息
    const context = getContext()
    // 加载 src/main/resources/rawfile 文件夹中的文件
    const fileDescriptor = await context.resourceManager.getRawFd(rawFdPath)
    // 设置播放路径
    player.fdSrc = fileDescriptor
  }

  // 停止播放
  async stop() {
    const player = await this.getAVPlayerInstance()
    player.stop()
  }

  // 暂停播放
  async pause() {
    const player = await this.getAVPlayerInstance()
    player.pause()
  }

  // 释放实例,任何时候都可以调用
  async release() {
    const player = await this.getAVPlayerInstance()
    player.release()
  }
}


export const avPlayerManager = new AVPlayerManager()