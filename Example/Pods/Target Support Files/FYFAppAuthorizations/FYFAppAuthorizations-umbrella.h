#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FYFAppAuthorizations.h"
#import "FYFCameraAuthorization.h"
#import "FYFPhotoAuthorization.h"

FOUNDATION_EXPORT double FYFAppAuthorizationsVersionNumber;
FOUNDATION_EXPORT const unsigned char FYFAppAuthorizationsVersionString[];

