//
//  HistoryTableViewCell.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 21/03/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryTableViewCell : UITableViewCell
- (void) setSong: (NSString*) song;
- (void) setArtist: (NSString*) artist;
- (void) setDate: (NSString*) date;
@end

NS_ASSUME_NONNULL_END
