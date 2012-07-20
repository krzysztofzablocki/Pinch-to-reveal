//
//  ViewController.m
//  BoeingProofOfConcept
//
//  Created by Krzysztof Zabłocki on 07/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ViewController ()

@end

@implementation ViewController {
  UIView *leftView;
  UIView *rightView;
  CGFloat divisionX;
}


- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background2.jpeg"]]];
  UIImage *frontImage = [UIImage imageNamed:@"Background.jpeg"];

  leftView = [[UIImageView alloc] initWithImage:frontImage];
  [self.view addSubview:leftView];

  rightView = [[UIImageView alloc] initWithImage:frontImage];
  [self.view addSubview:rightView];

  UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
  [self.view addGestureRecognizer:pinchGestureRecognizer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)divideBackgroundAtPoint:(CGPoint)point
{
  divisionX = point.x;

  CALayer *leftMask = [CALayer layer];
  leftMask.backgroundColor = [UIColor blackColor].CGColor;
  leftMask.frame = CGRectMake(0, 0, divisionX, leftView.bounds.size.height);
  leftView.layer.mask = leftMask;

  CALayer *rightMask = [CALayer layer];
  rightMask.backgroundColor = [UIColor blackColor].CGColor;
  rightMask.frame = CGRectMake(divisionX, 0, rightView.bounds.size.width - divisionX, rightView.bounds.size.height);
  rightView.layer.mask = rightMask;
}


- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
  if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan) {
    [self divideBackgroundAtPoint:[pinchGestureRecognizer locationInView:pinchGestureRecognizer.view]];
  }

  if ([pinchGestureRecognizer numberOfTouches] == 2) {
    float leftPoint = [pinchGestureRecognizer locationOfTouch:0 inView:pinchGestureRecognizer.view].x;
    float rightPoint = [pinchGestureRecognizer locationOfTouch:1 inView:pinchGestureRecognizer.view].x;
    if (leftPoint > rightPoint) {
      float tmp = rightPoint;
      rightPoint = leftPoint;
      leftPoint = tmp;
    }

    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationCurveEaseInOut animations:^() {
      leftView.frame = CGRectMake(MIN(leftPoint - divisionX, 0), leftView.frame.origin.y, leftView.bounds.size.width, leftView.bounds.size.height);
      rightView.frame = CGRectMake(MAX(rightPoint - divisionX, 0), rightView.frame.origin.y, rightView.bounds.size.width, rightView.bounds.size.height);
    }                completion:nil];
  }

  if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
    const CGFloat velocity = pinchGestureRecognizer.velocity;
    if (velocity < 0) {
      [self animateToClosePosition];
    } else {
      [self animateToOpenPosition];
    }
  }
}

- (void)animateToClosePosition
{
  [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationCurveEaseInOut animations:^() {
    leftView.frame = CGRectMake(0, 0, leftView.bounds.size.width, leftView.bounds.size.height);
    rightView.frame = CGRectMake(0, 0, leftView.bounds.size.width, leftView.bounds.size.height);
  }                completion:nil];
}

- (void)animateToOpenPosition
{
  [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationCurveEaseInOut animations:^() {
    leftView.frame = CGRectMake(-divisionX, 0, leftView.bounds.size.width, leftView.bounds.size.height);
    rightView.frame = CGRectMake(rightView.bounds.size.width - divisionX, 0, rightView.bounds.size.width, rightView.bounds.size.height);
  }                completion:nil];
}

@end