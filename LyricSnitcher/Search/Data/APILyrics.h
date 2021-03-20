//
//  APILyrics.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 18/03/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APILyrics : NSObject
@property (strong, nonatomic) NSString * lyrics;
-(instancetype) initWithLyrics: (NSString*) lyrics;
@end

NS_ASSUME_NONNULL_END
