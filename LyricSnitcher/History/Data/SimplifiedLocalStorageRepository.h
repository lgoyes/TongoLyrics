//
//  SimplifiedLocalStorageRepository.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 20/03/21.
//

#import <Foundation/Foundation.h>
#import "LocalStorageRepository.h"
#import "SimplifiedEntriesManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SimplifiedLocalStorageRepository : NSObject <LocalStorageRepositoryType>
- (NSArray*) getEntries;
@property (nonatomic) BOOL shouldSuccessfullyStoreEntry;
- (instancetype)initWithEntryManager: (SimplifiedEntriesManager*) manager;
@end

NS_ASSUME_NONNULL_END
