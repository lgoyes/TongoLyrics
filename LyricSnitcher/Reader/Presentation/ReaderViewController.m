//
//  ReaderViewController.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import "ReaderViewController.h"

@interface ReaderViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic) Lyrics * content;
@end

@implementation ReaderViewController
+ (ReaderViewController *)getInstanceWith:(Lyrics *)content {
    ReaderViewController * viewController = [[ReaderViewController alloc] initWithNibName:@"ReaderView" bundle:nil];
    viewController.content = content;
    return viewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text = _content.song;
    _subTitleLabel.text = _content.artist;
    _contentLabel.text = _content.lyrics;
}
@end
