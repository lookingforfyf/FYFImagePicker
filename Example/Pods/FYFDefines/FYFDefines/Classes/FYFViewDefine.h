//
//  FYFViewDefine.h
//  Pods
//
//  Created by 范云飞 on 2021/8/20.
//

/** 是否刘海屏设备 */
static inline BOOL isNotchDevice() {
    static BOOL __efIsIphoneX = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)) {
            UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
            if (mainWindow.safeAreaInsets.bottom > 0.0) {
                __efIsIphoneX = YES;
            }
        }
    });
    return __efIsIphoneX;
}

static inline CGFloat getSafeAreaBottom() {
    static CGFloat __efSafeAreaBottom = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)) {
            UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
            CGFloat bottom = mainWindow.safeAreaInsets.bottom;
            __efSafeAreaBottom = bottom;
        }
    });
    return __efSafeAreaBottom;
}
static inline CGFloat getNavigationBarHeight() {
    static CGFloat __efgetNavigationBarHeight = 44;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if (isNotchDevice()) {
                /// 全面屏pad 是 50
                __efgetNavigationBarHeight = 50.f;
            } else {
                if (@available(iOS 12.0, *)) {
                    /// 普通屏pad ios12后也是50
                    __efgetNavigationBarHeight = 50.f;
                }
            }
        }
    });
    return __efgetNavigationBarHeight;
}

static inline CGFloat getTabBarHeight() {
    static CGFloat __efgetTabBarHeight = 49;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if (isNotchDevice()) {
                /// 全面屏pad是45，外加底部20的安全区域就是65
                __efgetTabBarHeight = 45.f;
            } else {
                if (@available(iOS 12.0, *)) {
                    /// 普通屏pad ios12后也是50
                    __efgetTabBarHeight = 50.f;
                }
            }
        }
    });
    return __efgetTabBarHeight;
}

#ifndef FYFViewDefine_h
#define FYFViewDefine_h

#define FYF_IS_LANDSCAPE (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))

#define FYFScreenHeight   ([[UIScreen mainScreen] bounds].size.height)
#define FYFScreenWidth    ([[UIScreen mainScreen] bounds].size.width)

/// 设备宽度，跟横竖屏无关
#define FYFDeviceWidth MIN(FYFScreenWidth, FYFScreenHeight)
/// 设备高度，跟横竖屏无关
#define FYFDeviceHeight MAX(FYFScreenWidth, FYFScreenHeight)

#define FYFViewScale(a) ceil((FYFDeviceWidth / 375.0) * a)
#define FYFStatusBarCurrHeight  [[UIApplication sharedApplication] statusBarFrame].size.height
//状态栏实际高度
#define FYFStatusBarHeight  (FYFIsHotSpotOrCallingState?(FYFStatusBarCurrHeight-FYFSysHotSpotStatusBarHeight):FYFStatusBarCurrHeight) //状态栏高度
#define FYFNavigationBarHeight (getNavigationBarHeight()) //顶部导航栏的高度

//iPhoneX机型判断
#define FYF_IS_IPHONE_X isNotchDevice()

/** 状态栏高度 iphone X 的高度没有添加20 而是在左上角变化颜色 */
#define FYFSysStatusBarHeight (FYF_IS_IPHONE_X? 44.0f:20.0f) // 标准系统状态栏高度

#define FYFSafeArea_NavBarHeight 44

#define FYFSafeArea_TopBarHeight    (FYF_IS_IPHONE_X ? 88.f : 64.f)
#define FYFSafeArea_TopMargin       (FYF_IS_IPHONE_X ? 24.f : 0.f)
#define FYFSafeArea_BottomMargin    (FYF_IS_IPHONE_X ? 34.f : 0.f)

#define FYFSysHotSpotStatusBarHeight (FYF_IS_IPHONE_X? 0.0f:20.0f) // 热点栏高度
#define FYFIsHotSpotOrCallingState  (FYF_IS_IPHONE_X? NO:(FYFStatusBarCurrHeight >= (FYFSysStatusBarHeight + FYFSysHotSpotStatusBarHeight))?YES:NO) // 根据APP_STATUSBAR_HEIGHT判断是否存在热点栏 X中永远是NO
#define FYFHotSpotStatusBarHeight (FYFIsHotSpotOrCallingState? 20.0f:0.0f)

/** 导航栏磨沙适配 */
#define FYFNavigationBarAdapterContentInsetTop (FYFStatusBarHeight + FYFNavigationBarHeight) //顶部偏移
#define FYFNavigationBarAdapterContentInsetBottom (getSafeAreaBottom() + FYFTabbarSingleHeight) //底部偏移

/** 屏幕尺寸 */
#define FYFTabbarSingleHeight (getTabBarHeight()) /// tabbar高度
#define FYFNavigationBarFullHeight (FYFStatusBarHeight + FYFNavigationBarHeight) //顶部导航栏的高度
#define FYFNavigationBarTopSpace ([[UIApplication sharedApplication] statusBarFrame].size.height)

//导航栏距离顶部的间距
#define FYFTabbarFullHeight (getSafeAreaBottom() + FYFTabbarSingleHeight)  //底部tabbar的高度
#define FYFTabbarBottomSpace getSafeAreaBottom()  //IphoneX距离底部间距
#define FYFLeftSpaceLandscape (FYF_IS_IPHONE_X? 44.0f:0.0f)  //IphoneX横屏左边间距
#define FYFTopSpaceLandscape (FYF_IS_IPHONE_X? 20.0f:0.0f)  //IphoneX顶部间距


#endif /* FYFViewDefine_h */
