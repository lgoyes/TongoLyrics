//
//  GetHistoryInteractor.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 20/03/21.
//

#import <Foundation/Foundation.h>
#import "HistoryGetable.h"
#import "SystemConfig.h"
#import "LocalStorageRepository.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetHistoryInteractor : NSObject <HistoryGetable>
- (instancetype) initWithSystemConfig:(SystemConfigType) systemConfig;
@property (strong, nonatomic) id<LocalStorageRepositoryType> localStorageRepository;
@end

NS_ASSUME_NONNULL_END
