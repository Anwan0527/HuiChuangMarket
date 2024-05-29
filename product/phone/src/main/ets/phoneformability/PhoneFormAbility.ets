import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';

import type fileFs from '@ohos.file.fs'
import fs from '@ohos.file.fs'
import { request } from '@kit.BasicServicesKit';
import { fetchData } from '@CH/common/Index';

// 获取接口图片
export interface Result {
  counts: number;
  items: Item[];
  page: number;
  pages: number;
  pageSize: number;
}

export interface Item {
  desc: string;
  id: string;
  name: string;
  orderNum: number;
  picture: string;
  price: string;
}


const getImages = () => {
  return fetchData<Result>({
    url: '/home/goods/guessLike'
  })
}

function getRandomImages(images: string[]) {
  if (images.length < 2) {
    throw new Error('Array must contain at least two images.')
  }

  let index1: number, index2: number
  do {
    index1 = Math.floor(Math.random() * images.length)
    index2 = Math.floor(Math.random() * images.length)
  } while (index1 === index2); // 确保两个索引不相同

  return [images[index1], images[index2]]
}

const goodsList = [
  'http://yjy-xiaotuxian-dev.oss-cn-beijing.aliyuncs.com/picture/2021-04-05/6fdcac19-dd44-442c-9212-f7ec3cf3ed18.jpg',
  'http://yjy-xiaotuxian-dev.oss-cn-beijing.aliyuncs.com/picture/2021-04-05/6fdcac19-dd44-442c-9212-f7ec3cf3ed18.jpg'
]
const newGoodsList = [
  'https://yanxuan-item.nosdn.127.net/605d71caa460e3c05cb2fd1b2885b9b4.jpg',
  'https://yanxuan-item.nosdn.127.net/605d71caa460e3c05cb2fd1b2885b9b4.jpg'
]

// 作用：下载需要的图片资源 然后把图片资源处理为下发给card组件使用的标准格式
class FormData {
  fileNameList: string[]
  formImages: Record<string, string | number>

  constructor(fileNameList: string[], formImages: Record<string, string | number>) {
    this.fileNameList = fileNameList
    this.formImages = formImages
  }
}

class LoadImageForFormData {
  // 初始FormData数据
  initialFormData = new FormData([], {})
  // 要下载的图片列表
  private imageUrls: string[]
  // 图片下载完毕执行函数
  private finishCb: (formInfo: formBindingData.FormBindingData) => void
  // 当前Ability
  private ability: FormExtensionAbility
  // 当前正在下载的图片下标
  private curIndex: number = 0
  // 本地地址
  private tempDir: string = ''
  // 内存中的图片对象
  private formImages: Record<string, string | number> = {}
  // 图片文件的名称列表
  private fileNameList: string[] = []

  constructor(imageUrls: string[], finishCb: (formInfo: formBindingData.FormBindingData) => void,
    ability: FormExtensionAbility) {
    this.imageUrls = imageUrls
    this.finishCb = finishCb
    this.ability = ability
    this.tempDir = ability.context.getApplicationContext().tempDir
  }

  // 动态添加要下载的图片
  addImage(imageUrls: string[]) {
    this.imageUrls = imageUrls
    return this
  }

  // 开始下载图片
  startLoad() {
    if (this.imageUrls.length === 0) {
      console.error('please provide download imglist')
      return
    }
    let netFile = this.imageUrls[this.curIndex] // 需要在此处使用真实的网络图片下载链接
    let fileName = 'file' + Date.now()
    let tmpFile = this.tempDir + '/' + fileName
    // tmpFile: /data/storage/el2/base/temp/file1708331593898
    request.downloadFile(
      this.ability.context,
      {
        url: netFile,
        filePath: tmpFile,
        enableMetered: true,
        enableRoaming: true
      }
    ).then((task) => {
      task.on('complete', () => {
        let file: fileFs.File
        try {
          // fs资源读取模块
          file = fs.openSync(tmpFile)
          this.formImages[fileName] = file.fd
        } catch (e) {
          console.error(`openSync failed: ${JSON.stringify(e)}`)
        }
        this.fileNameList.push(fileName)
        this.curIndex++
        if (this.curIndex < this.imageUrls.length) {
          // 如果还没下载完毕，继续下载
          this.startLoad()
        } else {
          // 全部下载完毕更新数据
          this.initialFormData.fileNameList = this.fileNameList
          this.initialFormData.formImages = this.formImages
          let formInfo = formBindingData.createFormBindingData(this.initialFormData)
          this.finishCb(formInfo)
        }
      })
    }).catch(() => {

    })
  }
}


export default class PhoneFormAbility extends FormExtensionAbility {
  onAddForm(want: Want): formBindingData.FormBindingData {
    const lf = new LoadImageForFormData(
      [],
      (formInfo: formBindingData.FormBindingData) => {
        // 找到要更新的卡片id
        const formId = want.parameters && want.parameters['ohos.extra.param.key.form_identity'].toString()
        // 根据卡片id和信息更新卡片内容
        formProvider.updateForm(formId, formInfo)
      },
      this
    )
    // 调用接口获取图片数据
    getImages().then((res) => {
      const images = getRandomImages(res.data.result.items.map(item => item.picture))
      lf.addImage(images).startLoad()
    })
    return formBindingData.createFormBindingData(lf.initialFormData);
  }

  onCastToNormalForm(formId: string) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdateForm(formId: string) {
    // Called to notify the form provider to update a specified form.
  }

  onChangeFormVisibility(newStatus: Record<string, number>) {
    // Called when the form provider receives form events from the system.
  }

  onFormEvent(formId: string, message: string) {
    // Called when a specified message event defined by the form provider is triggered.
    getImages().then((res) => {
      const images = getRandomImages(res.data.result.items.map(item => item.picture))
      const lF = new LoadImageForFormData(
        images,
        (formInfo: formBindingData.FormBindingData) => {
          // 根据卡片id和信息更新卡片内容
          formProvider.updateForm(formId, formInfo)
        },
        this
      )
      lF.startLoad()
    })
  }

  onRemoveForm(formId: string) {
    // Called to notify the form provider that a specified form has been destroyed.
  }

  onAcquireFormState(want: Want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
};