//
//  Carousel.m
//  myjam
//
//  Created by nazri on 1/7/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//


#import "Carousel.h"

@implementation Carousel

//@synthesize pageControl;
@synthesize images;
@synthesize scroller;

#pragma mark - Override images setter

- (void)setImages:(NSArray *)newImages
{
    if (newImages != images)
    {
        [newImages retain];
        [images release];
        images = newImages;
        
        [self setup];
    }
}

#pragma mark - Carousel setup

- (void)setup
{
    scroller = [[UIScrollView alloc] initWithFrame:self.frame];
    [scroller setDelegate:self];
    [scroller setShowsHorizontalScrollIndicator:NO];
    [scroller setPagingEnabled:YES];
    [scroller setBounces:NO];
    
    CGSize scrollerSize = scroller.frame.size;
    
    for (NSInteger i = 0; i < [self.images count]; i++)
    {
        CGRect slideRect = CGRectMake(scrollerSize.width * i, 0, scrollerSize.width, scrollerSize.height);
        
        UIView *slide = [[UIView alloc] initWithFrame:slideRect];
        [slide setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:[self.images objectAtIndex:i]];
//        [imageView setImage:[UIImage imageNamed:[self.images objectAtIndex:i]]];
        [slide addSubview:imageView];
        [imageView release];
        
        [scroller addSubview:slide];
        [slide release];
    }
    
//    UIPageControl *tempPageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollerSize.height - 20, scrollerSize.width, 20)];
//    [self setPageControl:tempPageControll];
//    [tempPageControll release];
//    [self.pageControl setNumberOfPages:[self.images count]];
    [scroller setContentSize:CGSizeMake(scrollerSize.width * [self.images count], scrollerSize.height)];
    
    [self addSubview:scroller];
    [scroller release];
//    [self addSubview:self.pageControl];
}

- (void)passTheValue:(int)currentPage
{
    [self.delegate didScrollToPage:currentPage];
}

#pragma mark - UIscrollerDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//	[self.pageControl setCurrentPage:page];
    [self passTheValue:page];
}

#pragma mark - Cleanup

- (void)dealloc
{
//    [pageControl release];
    [images release];
    [super dealloc];
}

@end

