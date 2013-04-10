//
//  Carousel.h
//  myjam
//
//  Created by nazri on 1/7/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageSliderDelegate <NSObject>
- (void)didScrollToPage:(int)page;
@end

@interface Carousel : UIView <UIScrollViewDelegate>
{
//    UIPageControl *pageControl;
    NSArray *images;
    UIScrollView *scroller;
}

//@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) UIScrollView *scroller;
@property (nonatomic, retain) id <ImageSliderDelegate> delegate;

- (void)setup;

@end
