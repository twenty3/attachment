//
//  ViewController.m
//  Attachment

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, retain) UIButton* button;
@property (nonatomic, retain) UIDynamicAnimator* animator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    CGSize parentSize = self.view.frame.size;
    
    const CGFloat diameter = 150.0;
    const CGPoint origin = {(parentSize.width - diameter) / 2.0, 100.0};
    
    // Step 1: Create a button with some gravity
    self.button = [[UIButton alloc] initWithFrame:(CGRect){origin, {diameter, diameter}}];
    [self.button setTitle:@"Whee!" forState:UIControlStateNormal];
    [self styleButton:self.button];
    
    [self.view addSubview:self.button];
    
    UIGravityBehavior* gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.button]];
    [self.animator addBehavior:gravityBehavior];
    
}

- (void) styleButton:(UIButton*)button
{
    button.backgroundColor = [UIColor purpleColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0];
    button.layer.cornerRadius = floor(self.button.bounds.size.height / 2.0);
}

@end