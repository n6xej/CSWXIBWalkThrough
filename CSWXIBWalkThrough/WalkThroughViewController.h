//
//  CSWWalkThroughViewController.h
//  CSWWalkThroughDemo
//
//  Created by Christopher Worley on 2/9/15.
//  Copyright (c) 2015 Christopher Worley. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WalkthroughViewControllerDelegate <NSObject>

@required

- (void)walkthroughCloseButtonPressed;
- (void)walkthroughNextButtonPressed;
- (void)walkthroughPrevButtonPressed;
- (void)walkthroughPageDidChange:(NSInteger)pageNumber;

@end

@protocol WalkthroughPage <NSObject>

- (void)walkthroughDidScroll:(CGFloat)position offset:(CGFloat)offset;

@end

@interface WalkThroughViewController : UIViewController <UIScrollViewDelegate, WalkthroughPage>

@property (nonatomic, assign) id <WalkthroughViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *controllers;
@property (strong, nonatomic) UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;

- (void)addViewController:(UIViewController *)vc;

@end