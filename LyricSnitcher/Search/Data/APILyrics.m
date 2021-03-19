//
//  APILyrics.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 18/03/21.
//

#import "APILyrics.h"

@implementation APILyrics
- (instancetype)initWithLyrics:(NSString *)lyrics {
    self = [super init];
    if (self) {
        _lyrics = lyrics;
    }
    return self;
}
@end
