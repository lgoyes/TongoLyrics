//
//  Lyrics.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Lyrics : NSObject
@property (nonatomic) NSString * lyrics;
@property (nonatomic) NSString * artist;
@property (nonatomic) NSString * song;
@property (nonatomic) NSDate * date;
-(instancetype) initWithLyrics: (NSString*) lyrics artist:(NSString*)artist song: (NSString*) song andDate:(NSDate*)date;
@end

NS_ASSUME_NONNULL_END
