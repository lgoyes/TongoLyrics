//
//  SearchEntity.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SearchEntityType <NSObject>

@end

@interface SearchEntity : NSObject <SearchEntityType>

@end

NS_ASSUME_NONNULL_END
