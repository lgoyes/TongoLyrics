//
//  SystemConfig.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    SystemConfigTypeDebug = 0,
    SystemConfigTypeStart = SystemConfigTypeDebug,
    SystemConfigTypeRelease = 1,
    SystemConfigTypeEnd = SystemConfigTypeRelease
} SystemConfigType;

@interface SystemConfig : NSObject
+ (SystemConfigType) getCurrent;
@end

NS_ASSUME_NONNULL_END
