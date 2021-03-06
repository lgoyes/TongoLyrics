//
//  GetLyricsInteractor.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <Foundation/Foundation.h>
#import "LyricsRepositoryProtocol.h"
#import "LocalStorageRepository.h"
#import "SystemConfig.h"
#import "LyricsGetable.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetLyricsInteractor : NSObject <LyricsGetable>
@property (strong, nonatomic) id<LyricsRepositoryProtocol> networkRepository;
@property (strong, nonatomic) id<LocalStorageRepositoryType> localStorageRepository;
- (instancetype) initWithSystemConfig:(SystemConfigType) systemConfig;
@end

NS_ASSUME_NONNULL_END
