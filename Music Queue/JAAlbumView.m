//
//  JAAlbumView.m
//  Music Queue
//
//  Created by Jack Arendt on 5/14/14.
//  Copyright (c) 2014 John Arendt. All rights reserved.
//

#import "JAAlbumView.h"
#import "PWProgressView.h"
#define IPAD_VERTICAL 1024
#define IPAD_HORIZONTAL 768
#define IPHONE_5_HEIGHT 568
#define IPHONE_4_HEIGHT 480
#define IPHONE_WIDTH 320

@implementation JAAlbumView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.layer.cornerRadius = 50.0f;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        
        self.progressView = [[PWProgressView alloc] init];
        self.progressView.layer.cornerRadius = 50.0f;
        self.progressView.clipsToBounds = YES;
        [self addSubview:self.progressView];
    }
    return self;
}

- (void)layoutSubviews
{
    //[self changeLayout:IPHONE_5_HEIGHT];
}

-(void)changeLayout:(NSInteger)height
{
    if(height == IPHONE_5_HEIGHT)
    {
        self.imageView.frame = CGRectMake(15, 75, 100, 100);
        self.imageView.layer.cornerRadius = 50;
        self.progressView.layer.cornerRadius = 50;
        self.progressView.frame = self.imageView.frame;
    }
    else if(height == IPHONE_WIDTH+IPHONE_5_HEIGHT)
    {
        self.imageView.frame = CGRectMake(15, 60, 200, 200);
        self.imageView.layer.cornerRadius = 100;
        self.progressView.layer.cornerRadius = 100;
        self.progressView.frame = self.imageView.frame;
    }
    else if(height == IPHONE_4_HEIGHT)
    {
        self.imageView.frame = CGRectMake(15, 75, 100, 100);
        self.imageView.layer.cornerRadius = 50;
        self.progressView.layer.cornerRadius = 50;
        self.progressView.frame = self.imageView.frame;
    }
    else if(height == IPHONE_4_HEIGHT + IPHONE_WIDTH)
    {
        self.imageView.frame = CGRectMake(15, 60, 200, 200);
        self.imageView.layer.cornerRadius = 100;
        self.progressView.layer.cornerRadius = 100;
        self.progressView.frame = self.imageView.frame;
    }
    
    else if(height == IPAD_HORIZONTAL)
    {
        self.imageView.frame = CGRectMake(50, 50, 200, 200);
        self.imageView.layer.cornerRadius = 100;
        self.progressView.layer.cornerRadius = 100;
        self.progressView.frame = self.imageView.frame;
    }
    
    else if(height == IPAD_VERTICAL)
    {
        self.imageView.frame = CGRectMake(284, 25, 200, 200);
        self.imageView.layer.cornerRadius = 100;
        self.progressView.layer.cornerRadius = 100;
        self.progressView.frame = self.imageView.frame;
        
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
