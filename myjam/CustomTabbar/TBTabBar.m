//
//  TBTabBar.m
//  TweetBotTabBar
//
//  Created by Jerish Brown on 6/27/11.
//  Copyright 2011 i3Software. All rights reserved.
//

#import "TBTabBar.h"
#import "TBTabButton.h"
#import "TBTabNotification.h"
#import <QuartzCore/QuartzCore.h>

@interface TBTabBar()

@property (retain) NSMutableArray *buttons;
@property (retain) NSMutableArray *buttonData;
@property (retain) NSMutableArray *statusLights;

-(void)setupButtons;
-(void)setupLights;

@end

@implementation TBTabBar
@synthesize buttons = _buttons, buttonData = _buttonData, statusLights = _statusLights, delegate;

-(id)initWithItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 36);
        
//        UIImage *i = [UIImage imageNamed:@"tab_bg"];
//        UIColor *c = [[UIColor alloc] initWithPatternImage:i];
//        
//        self.backgroundColor = c;
//        [c release];

        if ([items count] > 5) {
            [NSException raise:@"Too Many Tabs" format:@"A maximum of 5 tabs are allowed in the TBTabBar. %d were asked to be rendered", [items count]];
        }
        self.buttonData = [[NSMutableArray alloc] initWithArray:items];
        
        [self setupButtons];
//        [self setupLights];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frameSize andItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self.frame = frameSize;
        
        //        UIImage *i = [UIImage imageNamed:@"tab_bg"];
        //        UIColor *c = [[UIColor alloc] initWithPatternImage:i];
        //
        //        self.backgroundColor = c;
        //        [c release];
        
        if ([items count] > 5) {
            [NSException raise:@"Too Many Tabs" format:@"A maximum of 5 tabs are allowed in the TBTabBar. %d were asked to be rendered", [items count]];
        }
        self.buttonData = [[NSMutableArray alloc] initWithArray:items];
        
        [self setupButtonsWithHight:frameSize.size.height];
        //        [self setupLights];
    }
    return self;
}

-(void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    [self applyDefaultStyle];
}

- (void)applyDefaultStyle {
    // add the drop shadow
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0.0, 3);
    self.layer.shadowOpacity = 0.4f;
    self.layer.masksToBounds = NO;
    self.layer.shouldRasterize = YES;
}

-(void)setupButtons {
    NSInteger count = 0;
    NSInteger xExtra = 0;
    NSInteger buttonSize = floor(320 / [self.buttonData count]) - 1;
    self.buttons = [[NSMutableArray alloc] init];
    for (TBTabButton *info in self.buttonData) {
        NSInteger extra = 0;
        if ([self.buttonData count] % 2 == 1) {
            if ([self.buttonData count] == 5) {
                NSInteger i = (count + 1) + (floor([self.buttonData count] / 2));
                if (i == [self.buttonData count]) {
                    extra = 1;
                } else if (i == [self.buttonData count]+1) {
                    xExtra = 1;
                }
            } else if ([self.buttonData count] == 3) {
                buttonSize = floor(320 / [self.buttonData count]);
            }
        } else {
            if (count + 1 == 2) {
                extra = 1;
            } else if (count + 1 == 3) {
                xExtra = 1;
            }
        }
        NSInteger buttonX = (count * buttonSize);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake(buttonX, 0, buttonSize + count + xExtra, 30);
        UIImage *tabBarButtonBackground = [[UIImage imageNamed:@"tab_item_bg_"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        UIImage *tabBarButtonBackgroundHighlighted = [[UIImage imageNamed:@"tab_item_bg_selected"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//        [b setImage:[info icon] forState:UIControlStateNormal];
//        [b setImage:[info highlightedIcon] forState:UIControlStateHighlighted];
//        [b setImage:[info highlightedIcon] forState:UIControlStateSelected];
        [b setBackgroundImage:tabBarButtonBackground forState:UIControlStateNormal];
        [b setBackgroundImage:tabBarButtonBackgroundHighlighted forState:UIControlStateHighlighted];
        [b setBackgroundImage:tabBarButtonBackgroundHighlighted forState:UIControlStateSelected];
        [b setTitle:[info title] forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        [b addTarget:self action:@selector(touchDownForButton:) forControlEvents:UIControlEventTouchDown];
        [b addTarget:self action:@selector(touchUpForButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:b];
        [self.buttons addObject:b];
        count++;
    }
}

-(void)setupButtonsWithHight:(CGFloat)height {
    NSInteger count = 0;
    NSInteger xExtra = 0;
    NSInteger buttonSize = floor(320 / [self.buttonData count]);
    self.buttons = [[NSMutableArray alloc] init];
    for (TBTabButton *info in self.buttonData) {
        NSInteger extra = 0;
        if ([self.buttonData count] % 2 == 1) {
            if ([self.buttonData count] == 5) {
                NSInteger i = (count + 1) + (floor([self.buttonData count] / 2));
                if (i == [self.buttonData count]) {
                    extra = 1;
                } else if (i == [self.buttonData count]+1) {
                    xExtra = 1;
                }
            } else if ([self.buttonData count] == 3) {
                buttonSize = floor(320 / [self.buttonData count]);
            }
        } else {
            if (count + 1 == 2) {
                extra = 1;
            } else if (count + 1 == 3) {
                xExtra = 1;
            }
        }
        NSInteger buttonX = (count * buttonSize);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake(buttonX, 0, buttonSize + count + xExtra, height-6);
        UIImage *tabBarButtonBackground = [[UIImage imageNamed:@"tab_item_bg_"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        UIImage *tabBarButtonBackgroundHighlighted = [[UIImage imageNamed:@"tab_item_bg_selected"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        //        [b setImage:[info icon] forState:UIControlStateNormal];
        //        [b setImage:[info highlightedIcon] forState:UIControlStateHighlighted];
        //        [b setImage:[info highlightedIcon] forState:UIControlStateSelected];
        [b setBackgroundImage:tabBarButtonBackground forState:UIControlStateNormal];
        [b setBackgroundImage:tabBarButtonBackgroundHighlighted forState:UIControlStateHighlighted];
        [b setBackgroundImage:tabBarButtonBackgroundHighlighted forState:UIControlStateSelected];
        [b setTitle:[info title] forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        b.titleLabel.textAlignment = NSTextAlignmentCenter;
        b.titleLabel.numberOfLines = 0;
        b.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [b addTarget:self action:@selector(touchDownForButton:) forControlEvents:UIControlEventTouchDown];
        [b addTarget:self action:@selector(touchUpForButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:b];
        [self.buttons addObject:b];
        count++;
    }
}

-(void)setupLights {
    NSInteger count = 0;
    NSInteger xExtra = 0;
    NSInteger buttonSize = floor(320 / [self.buttonData count]) - 1;
    for (TBTabButton *info in self.buttonData) {
        NSInteger extra = 0;
        if ([self.buttonData count] % 2 == 1) {
            if ([self.buttonData count] == 5) {
                NSInteger i = (count + 1) + (floor([self.buttonData count] / 2));
                if (i == [self.buttonData count]) {
                    extra = 1;
                } else if (i == [self.buttonData count]+1) {
                    xExtra = 1;
                }
            } else if ([self.buttonData count] == 3) {
                buttonSize = floor(320 / [self.buttonData count]);
            }
        } else {
            if (count + 1 == 2) {
                extra = 1;
            } else if (count + 1 == 3) {
                xExtra = 1;
            }
        }
        NSInteger buttonX = (count * buttonSize) + count + xExtra;
        
        [[info notificationView] updateImageView];
        [[info notificationView] setAllFrames:CGRectMake(buttonX, self.frame.size.height, buttonSize + extra, 4)]; 
        [self addSubview:[info notificationView]];
        count++;
    }
}

-(void)showDefaults {
    [self touchDownForButton:[self.buttons objectAtIndex:0]];
    [self touchUpForButton:[self.buttons objectAtIndex:0]];
}

-(void)showViewControllerAtIndex:(NSUInteger)index {
    [self touchDownForButton:[self.buttons objectAtIndex:index]];
    [self touchUpForButton:[self.buttons objectAtIndex:index]];
}

-(void)touchDownForButton:(UIButton*)button {
    [button setSelected:YES];
    NSInteger i = [self.buttons indexOfObject:button];
    UIViewController *vc = [[self.buttonData objectAtIndex:i] viewController];
    [delegate switchViewController:vc];
}

-(void)touchUpForButton:(UIButton*)button {
    for (UIButton *b in self.buttons) {
        [b setSelected:NO];
    }
    [button setSelected:YES];
}

- (void)dealloc
{
    [_buttons release];
    [_buttonData release];
    [_statusLights release];
    [super dealloc];
}

@end
