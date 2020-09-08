//
//  SimpleImageLoader.h
//  bball
//
//  Created by Company Name on 7/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol SimpleImageLoaderDelegate;

@interface SimpleImageLoader : NSObject {
    id <SimpleImageLoaderDelegate> delegate;
	NSMutableData *receivedData;
    UIImageView *imageView;
    UIActivityIndicatorView *activityIndicator;
    UIButton * button;
    CGFloat MAX_IMG_Width;
    CGFloat MAX_IMG_Height;
    int imgTag;
}

@property CGFloat MAX_IMG_Width;
@property CGFloat MAX_IMG_Height;
@property int imgTag;

@property (nonatomic, retain) id <SimpleImageLoaderDelegate> delegate;
@property (nonatomic, retain) UIButton * button;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

-(void) loadImage:(NSString *)urlAddress;

-(UIImage *) thumbnailImageWithData:(NSData *)imgData;

@end

@protocol SimpleImageLoaderDelegate <NSObject>
@required
-(void) imgLoader:(SimpleImageLoader *)imgLoader processImage:(UIImage *)img ImageView:(UIImageView *)imgView ActivityIndicator:(UIActivityIndicatorView *)activityIndicatorView;
@end