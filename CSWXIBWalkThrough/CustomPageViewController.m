//
//  CustomPageViewController.m
//  DemoWalkthrough
//
//  Created by Christopher Worley on 4/15/15.
//  Copyright (c) 2015 Christopher Worley. All rights reserved.
//

#import "CustomPageViewController.h"

@interface CustomPageViewController ()

@end

@implementation CustomPageViewController

- (BOOL)shouldAutorotate {
	
	return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)walkthroughDidScroll:(CGFloat)position offset:(CGFloat)offset {
	
	CATransform3D tr = CATransform3DIdentity;
	tr.m34 = -1/500.0;
	
	self.titleLabel.layer.transform = CATransform3DRotate(tr, (CGFloat)M_PI * (1.0 - offset), 1, 1, 1);
	self.textLabel.layer.transform = CATransform3DRotate(tr, (CGFloat)M_PI * (1.0 - offset), 1, 1, 1);
	
	CGFloat tmpOffset = offset;
	if (tmpOffset > 1.0){
		tmpOffset = 1.0 + (1.0 - tmpOffset);
	}
	self.imageView.layer.transform = CATransform3DTranslate(tr, 0 , (1.0 - tmpOffset) * 200, 0);
}

@end
