//
//  GetLastEntryInteractor.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 21/03/21.
//

#import <Foundation/Foundation.h>
#import "LastEntryGetable.h"
#import "SystemConfig.h"
#import "LocalStorageRepository.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetLastEntryInteractor : NSObject <LastEntryGetable>
- (instancetype) initWithSystemConfig:(SystemConfigType) systemConfig;
@property (strong, nonatomic) id<LocalStorageRepositoryType> localStorageRepository;
@end

NS_ASSUME_NONNULL_END
