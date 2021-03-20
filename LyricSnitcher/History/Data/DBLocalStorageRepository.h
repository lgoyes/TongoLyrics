//
//  DBLocalStorageRepository.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <Foundation/Foundation.h>
#import "LocalStorageRepository.h"
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBLocalStorageRepository : NSObject <LocalStorageRepositoryType>
@property (weak, nonatomic) NSManagedObjectContext * context;
@end

NS_ASSUME_NONNULL_END
