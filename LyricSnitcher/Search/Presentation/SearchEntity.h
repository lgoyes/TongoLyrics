//
//  SearchEntity.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <Foundation/Foundation.h>
#import "SearchPresentationContract.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchEntity : NSObject <SearchEntityType>
@property (weak, nonatomic) id<SearchControllerType> controller;
@end

NS_ASSUME_NONNULL_END
