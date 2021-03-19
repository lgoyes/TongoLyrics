//
//  SystemConfig.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import "SystemConfig.h"

@implementation SystemConfig
+ (SystemConfigType)getCurrent {
#if DEBUG
    return SystemConfigTypeDebug;
#else
    return SystemConfigTypeRelease;
#endif
}
@end
