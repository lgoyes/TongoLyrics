//
//  SearchViewController.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import "SearchViewController.h"
#import "SearchEntity.h"
#import "SearchPresentationContract.h"
#import "ReaderViewController.h"

@interface SearchViewController()
@property (weak, nonatomic) IBOutlet UITextField *songTextField;
@property (weak, nonatomic) IBOutlet UITextField *artistTextField;
@property (weak, nonatomic) IBOutlet UIButton *getLyricsButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingLyricsActivityIndicator;
@property (weak, nonatomic) IBOutlet UIStackView *previousSearchStackContainer;

@property (strong, nonatomic) id<SearchEntityType> entity;
@end

@implementation SearchViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _entity = [[SearchEntity alloc] init];
        [_entity setController:self];
    }
    return self;
}

- (IBAction)onGetLyricsButtonPressed:(UIButton *)sender {
    [_entity onSearchButtonPressed];
}

- (NSString *)getArtist {
    return _artistTextField.text;
}

- (NSString *)getSong {
    return _songTextField.text;
}

- (void)hideArtistError {
    _artistTextField.backgroundColor = UIColor.systemBackgroundColor;
}


- (void)hideSongError {
    _songTextField.backgroundColor = UIColor.systemBackgroundColor;
}


- (void)setLoadingState {
    [_getLyricsButton setTitle:@"" forState:UIControlStateNormal];
    [_getLyricsButton setEnabled:false];
    [_loadingLyricsActivityIndicator setHidden:false];
}


- (void)setSteadyState {
    [_getLyricsButton setTitle:@"Get Lyrics" forState:UIControlStateNormal];
    [_getLyricsButton setEnabled:true];
    [_loadingLyricsActivityIndicator setHidden:true];
}


- (void)showArtistError {
    _artistTextField.backgroundColor = UIColor.systemRedColor;
}


- (void)showSongError {
    _songTextField.backgroundColor = UIColor.systemRedColor;
}

- (void)showError:(NSString *)message {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)navigateToReader:(Lyrics *)lyrics {
    ReaderViewController * viewController = [ReaderViewController getInstanceWith:lyrics];
    [self presentViewController:viewController animated:true completion:nil];
}

@end
