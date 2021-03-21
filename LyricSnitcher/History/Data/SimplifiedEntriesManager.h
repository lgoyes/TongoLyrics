//
//  SimplifiedEntriesManager.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 21/03/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimplifiedEntriesManager : NSObject
@property (strong, nonatomic) NSMutableArray* entries;
+ (id) sharedManager;
@end

NS_ASSUME_NONNULL_END
