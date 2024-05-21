import { Context } from '@kit.AbilityKit'
import { authentication } from '@kit.AccountKit'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { util } from '@kit.ArkTS'

export class HuaweiLoginManager {
  static requestLogin(ctx: Context, cb: (code: string) => void) {
    // 创建授权请求，并设置参数
    let authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest()
    // 获取手机号需要传如下scope，传参数之前需要先申请对应scope权限,才能返回对应数据
    authRequest.scopes = ['phone']
    // 获取code需传如下permission
    authRequest.permissions = ['serviceauthcode']
    // 用户是否需要登录授权，该值为true且用户未登录或未授权时，会拉起用户登录或授权页面
    authRequest.forceAuthorization = true
    // 用于防跨站点请求伪造，非空字符串即可
    authRequest.state = util.generateRandomUUID()
    // 华为登录
    try {
      let controller = new authentication.AuthenticationController(ctx)
      controller.executeRequest(authRequest, async (err, data) => {
        if (err) {
          hilog.error(0x0000, 'testTag', 'auth fail,error: %{public}s', JSON.stringify(err));
          return;
        }
        let authorizationWithHuaweiIDResponse = data as authentication.AuthorizationWithHuaweiIDResponse;
        let state = authorizationWithHuaweiIDResponse.state;
        if (state != undefined && authRequest.state != state) {
          hilog.error(0x0000, 'testTag', 'auth fail,The state is different: %{public}s',
            JSON.stringify(authorizationWithHuaweiIDResponse));
          return;
        }
        hilog.debug(0x0000, 'testTag', 'auth success: %{public}s',
          JSON.stringify(authorizationWithHuaweiIDResponse));
        let authorizationWithHuaweiIDCredential = authorizationWithHuaweiIDResponse.data!;
        let code = authorizationWithHuaweiIDCredential.authorizationCode;
        // 开发者拿到code之后做后端的登录逻辑
        if (code) {
          cb(code)
        }
      })
    } catch (error) {
      hilog.error(0x0000, 'testTag', 'auth failed: %{public}s', JSON.stringify(error))
    }
  }

  static cancelLogin(ctx: Context, cb?: () => void) {
    // 创建取消授权请求，并设置参数
    let cancelRequest = new authentication.HuaweiIDProvider().createCancelAuthorizationRequest();
    cancelRequest.state = util.generateRandomUUID();
    // 执行取消授权请求
    try {
      let controller = new authentication.AuthenticationController(ctx)
      controller.executeRequest(cancelRequest, (err, data) => {
        if (err) {
          hilog.error(0x0000, 'testTag', 'cancel fail,error: %{public}s', JSON.stringify(err))
          return
        }
        let cancelAuthorizationResponse = data as authentication.CancelAuthorizationResponse
        let state = cancelAuthorizationResponse.state
        if (state != undefined && cancelRequest.state != state) {
          hilog.error(0x0000, 'testTag', 'cancel fail,The state is different: %{public}s',
            JSON.stringify(cancelAuthorizationResponse))
          return
        }
        hilog.debug(0x0000, 'testTag', 'cancel success: %{public}s', JSON.stringify(cancelAuthorizationResponse))
        cb && cb()
      })
    } catch (error) {
      hilog.error(0x0000, 'testTag', 'cancel failed: %{public}s', JSON.stringify(error));
    }
  }
}