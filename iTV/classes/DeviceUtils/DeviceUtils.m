//
//  DeviceUtils.m
//  ZombieHero
//
//  Created by Ahmed Farghaly on 12/1/13.
//  Copyright (c) 2013 Ahmed Farghaly. All rights reserved.
//

#import "DeviceUtils.h"


BOOL _deviceIsRetina;
BOOL _originalIpad;
BOOL _isIOS6;
BOOL _isIOS7;
BOOL _isIPhone;
CGFloat _deviceScale;
CGRect _deviceLandscapeFrame;


inline BOOL DeviceIsiOS6()
{
    return _isIOS6;
}

inline BOOL DeviceIsiOS7()
{
    return _isIOS7;
}

inline BOOL DeviceIsiPhone()
{
    return _isIPhone;
}

inline BOOL DeviceIsiPad()
{
    return !DeviceIsiPhone();
}

inline BOOL DeviceIsNonRetinaiPhone()
{
    return !DeviceIsRetina() && DeviceIsiPhone();
}

inline BOOL DeviceIsNonRetinaiPad()
{
    return !DeviceIsRetina() && DeviceIsiPad();
}

inline BOOL DeviceIsRetinaiPhone()
{
    return DeviceIsRetina() && DeviceIsiPhone();
}

inline BOOL DeviceIsRetinaiPad()
{
    return DeviceIsRetina() && DeviceIsiPad();
}

inline BOOL DeviceIsRetina()
{
    return _deviceIsRetina;
}

inline CGFloat DeviceLandscapeWidth()
{
    return _deviceLandscapeFrame.size.width;
}

inline CGFloat DeviceLandscapeAdditionalWidth()
{
    return (DeviceIsiPhone()) ? DeviceLandscapeWidth() - 480.0f : 0.0f;
}

inline BOOL DeviceIs4Inch()
{
    return (DeviceLandscapeAdditionalWidth() > 20.0f);
}



@implementation DeviceUtils

static DeviceUtils *_sharedDeviceUtils = nil;

#pragma mark -
#pragma mark Singleton setup methods

+(DeviceUtils *)sharedDeviceUtils
{
    @synchronized([DeviceUtils class])
    {
        if(!_sharedDeviceUtils)
        {
            _sharedDeviceUtils = [[self alloc] init];
        }
        
        return _sharedDeviceUtils;
    }
    
    return nil;
}

+(id)alloc
{
    @synchronized([DeviceUtils class])
    {
        NSAssert(_sharedDeviceUtils == nil, @"Attempted to allocate a second instance of DeviceUtils singleton");
        
        _sharedDeviceUtils = [super alloc];
        return _sharedDeviceUtils;
    }
    
    return nil;
}

// -----------------------------------------


#pragma mark -
#pragma mark init

- (id)init
{
    self = [super init];
    
    if(self)
    {
        NSLog(@"[DeviceUtils init]");
        
        // device / OS version
        UIDevice *currentDevice = [UIDevice currentDevice];
        _isIPhone = [currentDevice userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
        _isIOS6 = [[currentDevice systemVersion] compare:@"6.0"] != NSOrderedAscending;
        _isIOS7 = [[currentDevice systemVersion] compare:@"7.0"] != NSOrderedAscending;
        
        // screen dimensions
        UIScreen *mainScreen = [UIScreen mainScreen];
        _deviceLandscapeFrame = [mainScreen applicationFrame];
        NSLog(@"device landscape frame: %@", NSStringFromCGRect(_deviceLandscapeFrame));
        CGFloat width = _deviceLandscapeFrame.size.width;
        CGFloat height = _deviceLandscapeFrame.size.height;
        if( width < height ) //force landscape frame, if width < height, this is portrait, flip
        {
            CGFloat temp = height;
            height = width;
            width = temp;
            
            _deviceLandscapeFrame.size = (CGSize){.width = width, .height = height };
        }
        
        // screen scale
        _deviceScale = mainScreen.scale;
        _deviceIsRetina = _deviceScale > 1.0f;
        
        return self;
    }
    
    return nil;
}

// ----------------------------------------



@end
