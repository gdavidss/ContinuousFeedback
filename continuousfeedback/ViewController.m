#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic) CGFloat red;
@property(nonatomic) CGFloat green;
@property(nonatomic) UILabel *label;
@property(nonatomic) CGFloat tickMultiplier;
@property(nonatomic) UIPanGestureRecognizer *panGesture;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) AVAudioPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
  _tickMultiplier = 2.5;
    
  [self setupAudioPlayer];
  [self setupView];
  [self setupGestureRecognizer];
  [self setupLabel];
}

- (void)setupAudioPlayer {
  // Get the main bundle for the app
  NSBundle *bundle = [NSBundle mainBundle];

  // Get the file URL for the sound file
  NSURL *url = [bundle URLForResource:@"tick" withExtension:@"wav"];

  // Set up the audio session
  AVAudioSession *session = [AVAudioSession sharedInstance];
  [session setCategory:AVAudioSessionCategoryPlayback error:nil];

  // Create the audio player
  _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
  _player.numberOfLoops =
      -1;  // -1 means the sound will be played indefinitely

  _player.rate = 1;
  // Check if the sound file supports variable playback speed
  _player.enableRate = YES;

  [_player play];
}

- (void)setupView {
  // Initialize the colors
  _red = 0.5;
  _green = 0.5;

  // Set the background color of the view to the initial color
  self.view.backgroundColor = [UIColor colorWithRed:_red
                                              green:_green
                                               blue:0.0
                                              alpha:1.0];

  // Create the scroll view and set its delegate to self
  _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
  _scrollView.delegate = self;
  [self.view addSubview:_scrollView];
}

- (void)setupGestureRecognizer {
  // Initialize the pan gesture
  _panGesture =
      [[UIPanGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handlePan:)];
  _panGesture.delegate = self;
  [_scrollView addGestureRecognizer:_panGesture];
}


- (void)labelTapped:(UITapGestureRecognizer *)sender {
  // Check if the label is upside down
  if (CGAffineTransformEqualToTransform(self.label.transform, CGAffineTransformMakeRotation(M_PI))) {
    // If it is, rotate it back to its normal orientation
    self.label.transform = CGAffineTransformMakeRotation(0);
      _label.frame = CGRectMake(0, 0, self.view.frame.size.width * 0.4,
                                self.view.frame.size.height * 0.3);
  } else {
    // If it's not, rotate it upside down
    self.label.transform = CGAffineTransformMakeRotation(M_PI);
    _label.frame = CGRectMake(0, 0, self.view.frame.size.width * 1.6,
                                self.view.frame.size.height * 0.3);
  }
}


- (void)setupLabel {
  _label = [[UILabel alloc] init];
  _label.font = [_label.font fontWithSize:80];
  _label.font = [UIFont fontWithName:@"Avenir" size:80];

  // Set the text of the label to the percentage value
  _label.text = @"50";

  // Set the text color of the label to white
  _label.textColor = [UIColor whiteColor];
    
    // Add a tap gesture recognizer to the label
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
    [self.label addGestureRecognizer:tapRecognizer];
    self.label.userInteractionEnabled = YES;


  // Create an NSMutableAttributedString object with the text of the label
  NSMutableAttributedString *attributedString =
      [[NSMutableAttributedString alloc] initWithString:_label.text];

  // Set the stroke color of the attributed string to black
  [attributedString addAttribute:NSStrokeColorAttributeName
                           value:[UIColor blackColor]
                           range:NSMakeRange(0, attributedString.length)];

  // Set the stroke width of the attributed string to 2 points
  [attributedString addAttribute:NSStrokeWidthAttributeName
                           value:@3
                           range:NSMakeRange(0, attributedString.length)];

  // Set the attributedText property of the label to the attributed string
  _label.attributedText = attributedString;

  // Center the text in the label
  _label.textAlignment = NSTextAlignmentCenter;

  _label.frame = CGRectMake(0, 0, self.view.frame.size.width * 0.4,
                            self.view.frame.size.height * 0.3);

  // Add the label to the view hierarchy
  [self.view addSubview:_label];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  // Get the current offset of the scroll view
  CGFloat y = scrollView.contentOffset.y;

  // Update the colors based on the scroll position
  _green =
      MAX(0.0, MIN(1.0, 0.5 - y / _scrollView.frame.size.height * 2));
  _red =
      MAX(0.0, MIN(1.0, 0.5 + y / _scrollView.frame.size.height * 2));

  NSString *stringValue =
      [NSString stringWithFormat:@"%.2d", (int)floor(_green * 100)];
  _label.text = stringValue;

  _player.rate = _green * _tickMultiplier;

  // Update the background color of the view
  self.view.backgroundColor = [UIColor colorWithRed:_red
                                              green:_green
                                               blue:0.0
                                              alpha:1.0];
}

#pragma mark - UIGestureRecognizerDelegate methods

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
  // Update the scroll view's content offset based on the user's pan gesture
  CGPoint translation = [gesture translationInView:_scrollView];
  CGPoint newOffset =
      CGPointMake(_scrollView.contentOffset.x,
                  _scrollView.contentOffset.y + translation.y);
  _scrollView.contentOffset = newOffset;
  [gesture setTranslation:CGPointZero inView:_scrollView];
}

@end

