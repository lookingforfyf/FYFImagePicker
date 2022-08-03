//
//  FYFObjectDefine.h
//  Pods
//
//  Created by 范云飞 on 2021/8/23.
//

#ifndef FYFObjectDefine_h
#define FYFObjectDefine_h

/**
 *  同步回调主线程
 */
#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

/**
 *  异步回调主线程
 */
#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#endif /* KSObjectDefine_h */
