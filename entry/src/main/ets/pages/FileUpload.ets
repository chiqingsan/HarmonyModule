import { imageUploadModule } from '../common/utils/ImgUpload';

@Entry
@Component
struct FileUpload {
  build() {
    Column() {
      Button("上传图片")
        .onClick(async () => {
          imageUploadModule.imageUpload("/upload", "image", 3)
        })
    }.width("100%").height("100%").justifyContent(FlexAlign.Center)
  }
}