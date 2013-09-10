//
//  ViewController.m
//  Attachment

#import "ViewController.h"

const CGFloat kButtonDiameter = 150.0;

@interface ViewController ()

@property (nonatomic, retain) UIButton* button;
@property (nonatomic, retain) UIPanGestureRecognizer* panRecognizer;
@property (nonatomic, retain) UIView* attachmentAnchorView;
@property (nonatomic, retain) UIView* attachmentLocationView;
@property (nonatomic, retain) UIDynamicAnimator* animator;
@property (nonatomic, retain) UIAttachmentBehavior* attachmentBehavior;
@property (nonatomic, retain) UIAttachmentBehavior* dragAttachmentBehavior;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.button = [[UIButton alloc] initWithFrame:(CGRect){CGPointZero, {kButtonDiameter, kButtonDiameter}}];
    [self.button setTitle:@"Whee!" forState:UIControlStateNormal];
    [self styleButton:self.button];
    [self layoutButton:self.button];
    
    [self.view addSubview:self.button];
    
    UIGravityBehavior* gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.button]];
    [self.animator addBehavior:gravityBehavior];
    
    CGPoint attachmentPoint = self.button.center;
        // the anchor point is relative to the animator's reference view, which happens
        // to be the button's parent
    attachmentPoint.x -= 50.0;
    attachmentPoint.y += 100.0;
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.button attachedToAnchor:attachmentPoint];
    
    // Add a view so we can visualize the attachment anchor
    [self createAttachmentAnchorView];
    self.attachmentAnchorView.center = attachmentPoint;
    [self.view addSubview:self.attachmentAnchorView];
    
    // We can also offset where the attachment is joined to the item
    UIOffset offset = {0.0, 0.0};
    //self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.button offsetFromCenter:offset attachedToAnchor:attachmentPoint];
    
    [self.animator addBehavior:self.attachmentBehavior];
    
    // We can adjust the 'springy-ness' of the attachment
    self.attachmentBehavior.damping = 0.1;
    self.attachmentBehavior.frequency = 1.0;
    
    // Add a view so we can visualize that attchment location
    [self createAttachmentLocationView];
    CGPoint location = [self.button convertPoint:self.button.center fromView:self.animator.referenceView];
    location.x += offset.horizontal;
    location.y += offset.vertical;
    self.attachmentLocationView.center = location;
    [self.button addSubview:self.attachmentLocationView];
    
    // Step 3: Setup a pan gesture recognizer so we can drag the button around
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.button addGestureRecognizer:self.panRecognizer];
}

- (void) styleButton:(UIButton*)button
{
    button.backgroundColor = [UIColor purpleColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0];
    button.layer.cornerRadius = floor(self.button.bounds.size.height / 2.0);
}

- (void) layoutButton:(UIButton*)button
{
    CGSize parentSize = self.view.frame.size;
    
    const CGPoint origin = {(parentSize.width - kButtonDiameter) / 2.0, 100.0};
    const CGSize size = {kButtonDiameter, kButtonDiameter};
    button.frame = (CGRect){origin, size};
}

- (void) createAttachmentAnchorView
{
    UIView* anchorView = [[UIView alloc] initWithFrame:(CGRect){0.0, 0.0, 10.0, 10.0}];
    anchorView.backgroundColor = [UIColor blueColor];
    anchorView.layer.cornerRadius = 5.0;
    self.attachmentAnchorView = anchorView;
}

- (void) createAttachmentLocationView
{
    UIView* locationView = [[UIView alloc] initWithFrame:(CGRect){0.0, 0.0, 10.0, 10.0}];
    locationView.backgroundColor = [UIColor greenColor];
    locationView.layer.cornerRadius = 5.0;
    self.attachmentLocationView = locationView;
}

#pragma mark - Actions

-(void) didPan:(UIPanGestureRecognizer*)panRecognizer
{
    // Step 3, Part 2:
    
    // We'll only add the attachment for dragging, when a drag starts
    // otherwise the attachment will hold the item in place even
    // when we are not moving it.
    if ( panRecognizer.state == UIGestureRecognizerStateBegan )
    {
        // Pin the drag attachment to the location we touched in the view
        // and add it to the animator
        CGPoint dragPoint = [panRecognizer locationInView:self.view];
        CGPoint buttonPoint = [panRecognizer locationInView:self.button];
        CGPoint buttonCenter = {CGRectGetMidX(self.button.bounds), CGRectGetMidY(self.button.bounds)};
        UIOffset offset = {buttonPoint.x - buttonCenter.x, buttonPoint.y - buttonCenter.y};
        self.dragAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.button offsetFromCenter:offset attachedToAnchor:dragPoint];
        [self.animator addBehavior:self.dragAttachmentBehavior];
    }
    else if ( panRecognizer.state == UIGestureRecognizerStateEnded )
    {
        [self.animator removeBehavior:self.dragAttachmentBehavior];
        self.dragAttachmentBehavior = nil;
    }
    else if ( panRecognizer.state == UIGestureRecognizerStateChanged )
    {
        [self.dragAttachmentBehavior setAnchorPoint:[panRecognizer locationInView:self.view]];
    }
}




@end