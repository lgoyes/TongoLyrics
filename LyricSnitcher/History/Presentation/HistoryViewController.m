//
//  HistoryViewController.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 21/03/21.
//

#import "HistoryViewController.h"
#import "HistoryEntity.h"

@interface HistoryViewController ()
@property (strong, nonatomic) id<HistoryEntityType> entity;
@end

@implementation HistoryViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _entity = [[HistoryEntity alloc] init];
        [_entity setController:self];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_entity start];
}

- (void)setEmptyState {
    
}

- (void)setLoadingState {
    
}

- (void)showError:(NSString *)message {
    
}

- (void)showHistory:(NSArray *)history {
    
}

@end
