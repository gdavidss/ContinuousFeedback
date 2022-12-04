//
//  ViewController.m
//  continuousfeedback
//
//  Created by Guilherme David on 03/12/22.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) CGFloat red;
@property (nonatomic) CGFloat green;
@property (nonatomic) UILabel *label;
@property (nonatomic) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Initialize the colors
      self.red = 0.5;
      self.green = 0.5;

      // Create the scroll view and set its delegate to self
      self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
      self.scrollView.delegate = self;
      [self.view addSubview:self.scrollView];

      // Set the background color of the view to the initial color
      self.view.backgroundColor = [UIColor colorWithRed:self.red green:self.green blue:0.0 alpha:1.0];
    
    // Initialize the pan gesture
     self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
     self.panGesture.delegate = self;
     [self.scrollView addGestureRecognizer:self.panGesture];
    
    self.label = [[UILabel alloc] init];
    self.label.font = [self.label.font fontWithSize:80];
    
    // Set the text of the label to the percentage value
    _label.text = @"50";
    
    // Set the text color of the label to white
    _label.textColor = [UIColor whiteColor];
    
    // Create an NSMutableAttributedString object with the text of the label
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.label.text];

    // Set the stroke color of the attributed string to black
    [attributedString addAttribute:NSStrokeColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attributedString.length)];

    // Set the stroke width of the attributed string to 2 points
    [attributedString addAttribute:NSStrokeWidthAttributeName value:@2 range:NSMakeRange(0, attributedString.length)];

    // Set the attributedText property of the label to the attributed string
    self.label.attributedText = attributedString;
    
    // Center the text in the label
    _label.textAlignment = NSTextAlignmentCenter;

    _label.frame = CGRectMake(0, 0, self.view.frame.size.width*0.4, self.view.frame.size.height*0.3);

    // Add the label to the view hierarchy
    [self.view addSubview:_label];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
  // Update the scroll view's content offset based on the user's pan gesture
  CGPoint translation = [gesture translationInView:self.scrollView];
  CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y + translation.y);
  self.scrollView.contentOffset = newOffset;
  [gesture setTranslation:CGPointZero inView:self.scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Get the current offset of the scroll view
     CGFloat y = scrollView.contentOffset.y;

     // Update the colors based on the scroll position
     self.green = MAX(0.0, MIN(1.0, 0.5 - y / self.scrollView.frame.size.height*2));
     self.red = MAX(0.0, MIN(1.0, 0.5 + y / self.scrollView.frame.size.height*2));
    
    NSString *stringValue = [NSString stringWithFormat:@"%.2d", (int)floor(self.green*100)];
    _label.text = stringValue;
    
     // Update the background color of the view
     self.view.backgroundColor = [UIColor colorWithRed:self.red green:self.green blue:0.0 alpha:1.0];
}

@end

