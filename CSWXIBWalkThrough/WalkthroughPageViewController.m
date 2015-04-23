//
//  BWWalkthroughPageViewController.m
//  DemoWalkthrough
//
//  Created by Christopher Worley on 4/15/15.
//  Copyright (c) 2015 Christopher Worley. All rights reserved.
//

#import "WalkthroughPageViewController.h"

typedef NS_ENUM(NSInteger, WalkthroughAnimationType) {
	WalkthroughAnimationLinear,  /// Notification won't animate
	WalkthroughAnimationCurve,   /// Notification will move in from the top, and move out again to the top
	WalkthroughAnimationZoom,    /// Notification will fall down from the top and bounce a little bit
	WalkthroughAnimationInOut    /// Notification will fade in and fade out
};

@interface WalkthroughPageViewController () <WalkthroughPage>
{
	NSMutableArray *subsWeights;
	IBInspectable CGPoint speed;
	IBInspectable CGPoint speedVariance;
	IBInspectable NSInteger animationType;
	IBInspectable BOOL animateAlpha;
}

@end

@implementation WalkthroughPageViewController

- (BOOL)shouldAutorotate {
	
	return NO;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if( self )
	{
		speed = CGPointZero;
		speedVariance = CGPointZero;
		animationType = WalkthroughAnimationLinear;
		animateAlpha = NO;
		UINib *nib = [UINib nibWithNibName:nibNameOrNil bundle:nil];
		NSArray *nibObjects = [nib instantiateWithOwner:self options:nil];
		self.view = nibObjects.lastObject;
		self.view.layer.masksToBounds = YES;
		
		subsWeights = [[NSMutableArray alloc]init];
		
		for (int i=0; i < [self.view.subviews count]; i++)
		{
			speed.x += speedVariance.x;
			speed.y += speedVariance.y;
			
			[subsWeights addObject:[NSValue valueWithCGPoint:speed]];
		}

	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.pageController setNumberOfPages:[self.controllers count]];
	[self.pageController setCurrentPage:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)walkthroughDidScroll:(CGFloat)position  offset:(CGFloat)offset
{

	for (int i = 0; i < [subsWeights count] ;i++)
	{
		// Perform Transition/Scale/Rotate animations
		switch (animationType)
		{
			
			case WalkthroughAnimationLinear:
				[self animationLinear:i offset:offset];
				break;
				
			case WalkthroughAnimationZoom:
				[self animationZoom:i offset:offset];
				break;
				
			case WalkthroughAnimationCurve:
				[self animationCurve:i offset:offset];
				break;
				
			case WalkthroughAnimationInOut:
				[self animationInOut:i offset:offset];
				break;
				
			default:
				[self animationLinear:i offset:offset];
				break;
		}
		
		// Animate alpha
		if (animateAlpha)
		{
			[self animationAlpha:i offset:offset];
		}
	}
}

- (void)animationLinear:(NSInteger)index offset:(CGFloat)offset
{
	CATransform3D transform = CATransform3DIdentity;
	
	CGFloat mx = (1.0 - offset) * 100;
	
	CGPoint pt = [subsWeights[index] CGPointValue];
	
	transform = CATransform3DTranslate(transform, mx * pt.x, mx * pt.y, 0 );
	
	NSArray *viewarray = [self.view subviews];
	
	UIView *subview = [viewarray objectAtIndex:index];
	subview.layer.transform = transform;
}

- (void)animationAlpha:(NSInteger)index offset:(CGFloat)offset
{
	UIView *cView = self.view.subviews[index];
	
	if(offset > 1.0){
		offset = 1.0 + (1.0 - offset);
	}
	cView.alpha = offset;
}


- (void)animationCurve:(NSInteger)index offset:(CGFloat)offset
{
	CATransform3D transform = CATransform3DIdentity;
	
	CGFloat x  = (1.0 - offset) * 10;
	
	CGPoint pt = [[subsWeights objectAtIndex:index] CGPointValue];
	
	transform = CATransform3DTranslate(transform, (pow(x,3) - (x * 25)) * pt.x, (pow(x,3) - (x * 20)) * pt.y, 0 );
	NSArray *viewarray = [self.view subviews];
	
	UIView *subview = [viewarray objectAtIndex:index];
	subview.layer.transform = transform;
}

- (void)animationZoom:(NSInteger)index offset:(CGFloat)offset
{
	CATransform3D transform = CATransform3DIdentity;
	
	CGFloat tmpOffset = offset;
	
	if(tmpOffset > 1.0){
		tmpOffset = 1.0 + (1.0 - tmpOffset);
	}
	CGFloat scale = (1.0 - tmpOffset);
	transform = CATransform3DScale(transform, 1 - scale , 1 - scale, 1.0);
	NSArray *viewarray = [self.view subviews];
	
	UIView *subview = [viewarray objectAtIndex:index];
	subview.layer.transform = transform;
}

- (void)animationInOut:(NSInteger)index offset:(CGFloat)offset
{
	CATransform3D transform = CATransform3DIdentity;

	CGFloat tmpOffset = offset;
	
	if(tmpOffset > 1.0){
		tmpOffset = 1.0 + (1.0 - tmpOffset);
	}
	
	CGPoint pt = [subsWeights[index] CGPointValue];
	
	transform = CATransform3DTranslate(transform, (1.0 - tmpOffset) * pt.x * 100, (1.0 - tmpOffset) * pt.y * 100, 0);
	NSArray *viewarray = [self.view subviews];
	
	UIView *subview = [viewarray objectAtIndex:index];
	subview.layer.transform = transform;
}

@end
