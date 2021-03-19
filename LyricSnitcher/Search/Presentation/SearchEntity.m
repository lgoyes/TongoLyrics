//
//  SearchEntity.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import "SearchEntity.h"
#import "GetLyricsInteractor.h"

@implementation SearchEntity
- (instancetype)init
{
    self = [super init];
    if (self) {
        _getLyricsInteractor = [[GetLyricsInteractor alloc] init];
    }
    return self;
}
- (BOOL)validateSongField {
    NSString * song = [_controller getSong];
    return (song != nil) && ![song isEqualToString:@""];
}
- (BOOL)validateArtistField {
    NSString * artist = [_controller getArtist];
    return (artist != nil) && ![artist isEqualToString:@""];
}
- (BOOL)validateForm {
    BOOL songValid = [self validateSongField];
    if (songValid) {
        [_controller hideSongError];
    } else {
        [_controller showSongError];
    }
    
    BOOL artistValid = [self validateArtistField];
    if (artistValid) {
        [_controller hideArtistError];
    } else {
        [_controller showArtistError];
    }
    
    return songValid && artistValid;
}
- (void) onSearchButtonPressed {
    BOOL isValid = [self validateForm];
    
}
@end
