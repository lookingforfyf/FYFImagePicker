//
//  FYFColorDefine.h
//  Pods
//
//  Created by 范云飞 on 2021/8/20.
//

#ifndef FYFColorDefine_h
#define FYFColorDefine_h

// RGB颜色方法
#define FYFColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define FYFColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#define FYFColorRGB(_r, _g, _b, _a)             [UIColor colorWithRed:_r/255.0 green:_g/255.0 blue:_b/255.0 alpha:_a]

#endif /* KSColorDefine_h */
