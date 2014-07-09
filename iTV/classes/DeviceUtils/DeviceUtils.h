//
//  DeviceUtils.h
//  ZombieHero
//
//  Created by Ahmed Farghaly on 12/1/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import <Foundation/Foundation.h>


CGFloat DeviceLandscapeWidth();
CGFloat DeviceLandscapeAdditionalWidth();

BOOL DeviceIsiPhone();
BOOL DeviceIsiPad();
BOOL DeviceIsNonRetinaiPhone();
BOOL DeviceIsNonRetinaiPad();
BOOL DeviceIsRetinaiPhone();
BOOL DeviceIsRetinaiPad();
BOOL DeviceIsRetina();
BOOL DeviceIsOriginalIpad();
BOOL DeviceIs4Inch();



@interface DeviceUtils : NSObject

+ (DeviceUtils *)sharedDeviceUtils;

@end
