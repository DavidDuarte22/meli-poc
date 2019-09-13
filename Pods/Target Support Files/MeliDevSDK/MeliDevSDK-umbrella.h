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

#import "Meli.h"
#import "MeliDevAccessToken.h"
#import "MeliDevAsyncHttpOperation.h"
#import "MeliDevErrors.h"
#import "MeliDevHttpOperation.h"
#import "MeliDevIdentity.h"
#import "MeliDevLoginViewController.h"
#import "MeliDevSyncHttpOperation.h"
#import "MeliDevUtils.h"

FOUNDATION_EXPORT double MeliDevSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char MeliDevSDKVersionString[];

