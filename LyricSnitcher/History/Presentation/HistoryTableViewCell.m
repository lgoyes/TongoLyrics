//
//  HistoryTableViewCell.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 21/03/21.
//

#import "HistoryTableViewCell.h"

@interface HistoryTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation HistoryTableViewCell
- (void)setSong:(NSString *)song {
    [_songLabel setText:song];
}
- (void)setArtist:(NSString *)artist {
    [_artistLabel setText:artist];
}
- (void)setDate:(NSString *)date {
    [_dateLabel setText:date];
}
@end
