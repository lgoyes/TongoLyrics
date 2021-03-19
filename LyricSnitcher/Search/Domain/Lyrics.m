//
//  Lyrics.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import "Lyrics.h"

@implementation Lyrics
- (instancetype)initWithLyrics:(NSString *)lyrics artist:(NSString *)artist song:(NSString *)song andDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _lyrics = lyrics;
        _artist = artist;
        _song = song;
        _date = date;
    }
    return self;
}
@end
