//
//  JAAlbumView.h
//  Music Queue
//
//  Created by Jack Arendt on 5/14/14.
//  Copyright (c) 2014 John Arendt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWProgressView;

@interface JAAlbumView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) PWProgressView *progressView;

-(void)changeLayout:(NSInteger)height;

@end
