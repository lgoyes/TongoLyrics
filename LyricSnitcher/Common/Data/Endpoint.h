//
//  Endpoint.h
//  LyricSnitcher
//
//  Created by Luis David Goyes on 1/04/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Endpoint : NSObject
@property (nonatomic, strong) NSString* _Nonnull url;
@property (nonatomic, strong) NSString* _Nonnull httpMethod;
@property (nonatomic, strong) NSDictionary* _Nullable body;
@end

NS_ASSUME_NONNULL_END
