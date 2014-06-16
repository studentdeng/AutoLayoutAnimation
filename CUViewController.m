//
//  CUViewController.m
//  AutoLayoutAnimation
//
//  Created by yuguang on 16/6/14.
//  Copyright (c) 2014 lion. All rights reserved.
//

#import "CUViewController.h"

@interface CUViewController ()

@property (nonatomic, strong) NSMutableArray *imageViewList;
@property (nonatomic, strong) NSArray *animationConstraints;
@property (weak, nonatomic) IBOutlet UIButton *animationButton;
@end

@implementation CUViewController
{
  BOOL _bExpand;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.

  self.imageViewList = [NSMutableArray array];
  for (int i = 0; i < 5; ++i) {
    UIImageView *imageView = [UIImageView new];
    imageView.frame = CGRectMake(0, 0, 20, 40);
    [self.imageViewList addObject:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.backgroundColor = [UIColor colorWithWhite:0 + 0.2 * i alpha:1.0];
    [self.view insertSubview:imageView belowSubview:self.animationButton];
  }
}

- (void)updateViewConstraints
{
  [super updateViewConstraints];
  
  for (int i = 0; i < self.imageViewList.count; ++i) {
    NSString *key = [@"imageView" stringByAppendingString:[@(i) stringValue]];
    NSString *hVFL = [NSString stringWithFormat:@"H:|-0-[%@]-0-|", key];
    NSDictionary *dictionary  =@{key : self.imageViewList[i]};
    
    NSArray *list =
    [NSLayoutConstraint constraintsWithVisualFormat:hVFL
                                            options:0
                                            metrics:nil
                                              views:dictionary];
    [self.view addConstraints:list];
  }

  [self reset];
}

- (IBAction)clicked:(id)sender {
  
  [self.view layoutIfNeeded];
  
  if (!_bExpand) {
    _bExpand = YES;
    
    [UIView animateWithDuration:.6f
                     animations:^{
                       
                       [self.view removeConstraints:_animationConstraints];
                       
                       int animationIndex = 2;
                       
                       NSString *language = @"V:|";
                       NSMutableArray *keys = [NSMutableArray array];
                       for (int i = 0; i < self.imageViewList.count; ++i) {
                         NSString *key = [@"imageView" stringByAppendingString:[@(i) stringValue]];
                         NSString *value = [NSString stringWithFormat:@"-0-[%@(50)]", key];
                         if (i == 0) {
                           value = [NSString stringWithFormat:@"-(-%d)-[%@(50)]", 50 * animationIndex,key];
                         }
                         if (i == animationIndex) {
                           value = [NSString stringWithFormat:@"-0-[%@(%f)]", key, self.view.frame.size.height];
                         }
                         
                         language = [language stringByAppendingString:value];
                         [keys addObject:key];
                       }
                       
                       NSDictionary *dic = [NSDictionary dictionaryWithObjects:self.imageViewList forKeys:keys];
                       
                       self.animationConstraints =
                       [NSLayoutConstraint constraintsWithVisualFormat:language
                                                               options:0
                                                               metrics:nil
                                                                 views:dic];
                       [self.view addConstraints:self.animationConstraints];
                       
                       [self.view layoutIfNeeded];
                     }];

  }
  else
  {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.6f
                     animations:^{
                       [self.view removeConstraints:_animationConstraints];
                       [self reset];
                       
                       [self.view layoutIfNeeded];
                     }];
    
    _bExpand = NO;
  }
}

- (void)reset
{
  NSString *language = @"V:|";
  NSMutableArray *keys = [NSMutableArray array];
  for (int i = 0; i < self.imageViewList.count; ++i) {
    NSString *key = [@"imageView" stringByAppendingString:[@(i) stringValue]];
    NSString *value = [NSString stringWithFormat:@"-0-[%@(50)]", key];
    language = [language stringByAppendingString:value];
    [keys addObject:key];
  }
  
  NSDictionary *dic = [NSDictionary dictionaryWithObjects:self.imageViewList forKeys:keys];
  
  self.animationConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:language
                                          options:0
                                          metrics:nil
                                            views:dic];
  
  [self.view addConstraints:self.animationConstraints];
}

@end
