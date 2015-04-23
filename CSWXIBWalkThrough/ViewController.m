//
//  ViewController.m
//  CWWalkThrough
//
//  Created by Christopher Worley on 4/22/15.
//  Copyright (c) 2015 Christopher Worley. All rights reserved.
//

#import "ViewController.h"
#import "WalkThroughViewController.h"
#import "WalkthroughPageViewController.h"
#import "CustomPageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:(BOOL)animated];
	
	if (![[NSUserDefaults standardUserDefaults] objectForKey:@"walkthroughPresented"])
	{
		[self showWalkthrough:nil];
		
		[[NSUserDefaults standardUserDefaults] setObject:@(YES)
												  forKey:@"walkthroughPresented"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)showWalkthrough:(id)sender {
	
	WalkThroughViewController *walkthrough = [[WalkThroughViewController alloc]init];

	WalkthroughPageViewController *page_one = [[WalkthroughPageViewController alloc]initWithNibName:@"WalkOne" bundle:nil];
	WalkthroughPageViewController *page_two = [[WalkthroughPageViewController alloc]initWithNibName:@"WalkTwo" bundle:nil];
	CustomPageViewController *page_three = [[CustomPageViewController alloc]initWithNibName:@"WalkThree" bundle:nil];
	WalkthroughPageViewController *page_zero = [[WalkthroughPageViewController alloc]initWithNibName:@"WalkZero" bundle:nil];

	// Attach the pages to the master
	walkthrough.delegate = self;
	
	[walkthrough addViewController:page_one];
	[walkthrough addViewController:page_two];
	[walkthrough addViewController:page_three];
	[walkthrough addViewController:page_zero];
	
	[self presentViewController:walkthrough animated:YES completion:nil];
}

#pragma - DELEGATE
- (void)walkthroughCloseButtonPressed
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)walkthroughNextButtonPressed
{
	NSLog(@"Next");
}

- (void)walkthroughPrevButtonPressed
{
	NSLog(@"Prev");
}

- (void)walkthroughPageDidChange:(NSInteger)pageNumber
{
	NSLog(@"%ld",(long)pageNumber);
}

@end
