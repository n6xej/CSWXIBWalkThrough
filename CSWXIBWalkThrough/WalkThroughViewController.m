//
//  CSWWalkThroughViewController.m
//  CSWWalkThroughDemo
//
//  Created by Christopher Worley on 2/9/15.
//  Copyright (c) 2015 Christopher Worley. All rights reserved.
//

#import "WalkThroughViewController.h"
#import "WalkthroughPageViewController.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface WalkThroughViewController ()
{
	NSArray *lastViewConstraint;
	NSInteger currentPage;
}

@end

@implementation WalkThroughViewController
- (BOOL)shouldAutorotate {
	
	return NO;
}

- (instancetype)init
{
	if (self = [super init])
	{
		self.scrollview = [[UIScrollView alloc]init];
		[self.scrollview setShowsHorizontalScrollIndicator:NO];
		[self.scrollview setShowsVerticalScrollIndicator:NO];
		[self.scrollview setPagingEnabled:YES];
		self.controllers = [[NSMutableArray alloc]init];
	}
	return self;
}

- (NSInteger)currentPage
{
	CGFloat val = self.scrollview.contentOffset.x / self.view.bounds.size.width;
	NSInteger page = (NSInteger)val;
	
	return page;
}


- (void)addViewController:(UIViewController *)vc
{
	
	[self.controllers addObject:vc];
	
	[vc.view setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.scrollview addSubview:vc.view];

	NSLayoutFormatOptions options = 0;

	NSDictionary *metricDict = @{@"w": @(SCREEN_WIDTH),
							  @"h": @(SCREEN_HEIGHT)};

	NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(h)]"
														  options:options
														  metrics:metricDict
															views:@{@"view":vc.view}];
	[vc.view addConstraints:constraints];

	constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(w)]"
														  options:options
														  metrics:metricDict
															views:@{@"view":vc.view}];
	[vc.view addConstraints:constraints];
	
	constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]|"
														  options:options
														  metrics:metricDict
															views:@{@"view":vc.view}];
	[self.scrollview addConstraints:constraints];
	
	// cnst for position: 1st element
	if ([self.controllers count] == 1)
	{
		constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]"
															  options:0
															  metrics:nil
																views:@{@"view":vc.view}];
		[self.scrollview addConstraints:constraints];
	}
	else
	{
		// cnst for position: other elements
		UIViewController *previousVC = [self.controllers objectAtIndex:([self.controllers count] - 2) ];
		
		UIView *previousView = previousVC.view;
		
		constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView]-0-[view]"
															  options:0
															  metrics:nil
																views:@{@"previousView": previousView,
																		@"view": vc.view}];
		[self.scrollview addConstraints:constraints];

		 
		NSArray *cst = lastViewConstraint;
		
		if (cst) {
			[self.scrollview removeConstraints:cst];
		}
		
		lastViewConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-|" options:0 metrics:nil views:@{@"view": vc.view}];
		[self.scrollview addConstraints:lastViewConstraint];
	}

}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.scrollview.delegate = self;
	[self.scrollview setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view insertSubview:self.scrollview atIndex:0];

	NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollview]-0-|"
														  options:0
														  metrics:nil
															views:@{@"scrollview":self.scrollview}];
	[self.view addConstraints:constraints];
	
	constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollview]-0-|"
														  options:0
														  metrics:nil
															views:@{@"scrollview":self.scrollview}];
	[self.view addConstraints:constraints];
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.pageController setNumberOfPages:[self.controllers count]];
	[self.pageController setCurrentPage:0];
}

- (IBAction)nextPage:(id)sender
{
	if ((self.currentPage + 1) < [self.controllers count])
	{
		
		[self.delegate walkthroughNextButtonPressed];

		CGRect frame = self.scrollview.frame;
		frame.origin.x = (CGFloat)(self.currentPage + 1) * frame.size.width;
		[self.scrollview scrollRectToVisible:frame animated:YES];
	}
}
- (IBAction)prevPage:(id)sender 
{
	if (self.currentPage > 0)
	{
		[self.delegate walkthroughNextButtonPressed];

		CGRect frame = self.scrollview.frame;
		frame.origin.x = (CGFloat)(self.currentPage - 1) * frame.size.width;
		[self.scrollview scrollRectToVisible:frame animated:YES];
	}
}
	
- (IBAction)close:(id)sender
{
	[self.delegate walkthroughCloseButtonPressed];
}

- (void)updateUI
{
	// Get the current page
	self.pageController.currentPage = self.currentPage;
	
	// Notify delegate about the new page
	[self.delegate walkthroughPageDidChange:self.currentPage];
	
	[self.nextButton setHidden:(self.currentPage == [self.controllers count] - 1) ? YES : NO];
	
	[self.prevButton setHidden:(self.currentPage == 0) ? YES : NO];
}

#pragma - Scrollview Delegate

- (void)walkthroughDidScroll:(CGFloat)position  offset:(CGFloat)offset
{
	// required for delegate
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollview
{

	for (int i=0; i < [self.controllers count]; i++)
	{
		UIViewController <WalkthroughPage> *vc = [self.controllers objectAtIndex:i];

		CGFloat mx = ((scrollview.contentOffset.x + self.view.bounds.size.width) - (self.view.bounds.size.width * (CGFloat)i)) / self.view.bounds.size.width;
		
		// While sliding to the "next" slide (from right to left), the "current" slide changes its offset from 1.0 to 2.0 while the "next" slide changes it from 0.0 to 1.0
		// While sliding to the "previous" slide (left to right), the current slide changes its offset from 1.0 to 0.0 while the "previous" slide changes it from 2.0 to 1.0
		// The other pages update their offsets whith values like 2.0, 3.0, -2.0... depending on their positions and on the status of the walkthrough
		// This value can be used on the previous, current and next page to perform custom animations on page's subviews.
		
		// print the mx value to get more info.
		// println("\(i):\(mx)")
		
		// We animate only the previous, current and next page
		if (mx < 2.0f && mx > -2.0f)
		{
			[vc walkthroughDidScroll:scrollview.contentOffset.x offset:mx];
		}
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self updateUI];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	[self updateUI];
}

@end
