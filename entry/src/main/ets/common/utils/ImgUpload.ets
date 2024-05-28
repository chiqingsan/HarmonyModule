import { fileIo, picker } from '@kit.CoreFileKit'
import { request } from '@kit.BasicServicesKit';
import { http } from '@kit.NetworkKit';
import { promptAction } from '@kit.ArkUI';

// 图片上传的基地址,按需求更改
const Url_Base = "https://www.imgtp.com/api"

class ImageUploadModule {
  private Url_Base: string

  constructor(Url_Base: string) {
    this.Url_Base = Url_Base
  }

  // 选择图片,返回选择图片的地址
  async pickerAvatar(selectNum: number = 1) {
    // 规定选择的合法数量
    if (selectNum < 1) {
      selectNum = 1
    } else if (selectNum > 9) {
      selectNum = 9
    }
    // 实例化选择参数的对象
    const options = new picker.PhotoSelectOptions()
    // 设定需要选择的文件类型, 这里只选择图片
    options.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
    // 设定选择的数量, 这里只需要选择一张
    options.maxSelectNumber = selectNum

    // 实例化选择器, 然后选入设定好的对象
    const pickerView = new picker.PhotoViewPicker
    // 调用选择器, 并且接受返回的结果
    const ImgResults = await pickerView.select(options)

    // 判断是否选择了图片,如果取消了图片选择,则使用Promise抛出异常
    if (ImgResults.photoUris.length > 0) {
      return Promise.resolve(ImgResults.photoUris)
    } else {
      // console.warn("取消了图片选择")
      return Promise.reject("用户取消了图片选择")
    }
  }

  // 拿到地址, 拷贝到应用的缓存目录. 然后上传图片
  // 注意, 这里处理单张图片路径! name的参数为后端规定的图片name格式!!! 常见为:img/image/file等...
  fileCopies(ImagePath: string, name: string): request.File {
    // 使用文件管理模块打开,拿到源文件
    const file = fileIo.openSync(ImagePath, fileIo.OpenMode.READ_ONLY)

    // 设置一下需要拷贝到缓存目录的图片名字
    const filename = `${Date.now()}_${Math.floor(Math.random() * 1000)}`
    // 动态取到文件名的格式后缀, 一般是jpg/png格式
    const extension = ImagePath.slice(ImagePath.lastIndexOf(".") + 1)

    // 把路径和文件名组合
    const copyThePath = `${getContext().cacheDir}/${filename}.${extension}`
    // 打印一下准备复制的路径做确认
    console.log(copyThePath)
    // 拿到源文件的唯一表示,和准备复制的路径,把相册中的图片复制到应用自身的沙箱中
    fileIo.copyFileSync(file.fd, copyThePath)

    return {
      filename: `${filename}.${extension}`,
      type: extension,
      name: name,
      uri: `internal://cache/${filename}.${extension}`
    }
  }

  // 上传图片
  async uploadAnImage(url: string, fileArr: request.File[]) {

    const files: Array<request.File> = fileArr

    console.log("FileUpload:", JSON.stringify("开始准备文件上传"))
    // 开始准备上传图片,需要两个参数,一个是上下文对象,一个是上传的配置
    const res = await request.uploadFile(getContext(), {
      url: this.Url_Base + url,
      method: http.RequestMethod.POST,
      header: {
        "Content-Type": 'multipart/form-data',
        // "Authorization": `Bearer ${"token"}`  看需求,是否需要携带token
      },
      files,
      data: []
    })

    // 这里是监听上传的进度
    res.on("progress", async (progress, totalSize) => {
      console.info("当前上传进度为:", `${progress / totalSize * 100}%`)
      // 如果上传大小等于总大小,则说明上传完成
      if (progress === totalSize) {
        promptAction.showToast({ message: "图片上传成功" })
      }
    })

    // 这里是监听上传响应的标头
    res.on("headerReceive", (header) => {
      // 打印标头信息, 这里包含上传的图片访问地址
      console.log("FileUpload:", JSON.stringify(header))
    })
  }

  // 对上传图片的全部步骤完成函数封装
  async imageUpload(url: string, name: string, selectNum = 1) {
    try {
      // 拉起图片选择器, 如果用户取消选择则进入catch,代码不会往下执行
      // 默认选择图片为一张
      const photoUris = await this.pickerAvatar(selectNum)
      // 拿到拷贝到应用沙箱的文件配置对象列表
      const files = photoUris.map(v => this.fileCopies(v, name))
      // 开始准备上传图片
      this.uploadAnImage(url, files)
    } catch (e) {
      // 打印错误
      console.log("ImgUpload:", JSON.stringify(e))
    }
  }
}

// 实例化图片上传实例,然后导出
export const imageUploadModule = new ImageUploadModule(Url_Base)

