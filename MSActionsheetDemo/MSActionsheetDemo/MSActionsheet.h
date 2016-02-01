//
//  MSActionsheet.h
//  MSActionsheetDemo
//
//  Created by 阮明森 on 16/2/1.
//  Copyright © 2016年 rms. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSActionSheetDelegate;

@interface MSActionsheet : UIView

@property (nonatomic, weak) id<MSActionSheetDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cancelButtonTitle;

- (id)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

//a coverView
@property (strong, nonatomic) UIView *backgroundView;

// Set the contentView for the action sheet
// The frame of action sheet will be resized based on the frame of contentView
@property (nonatomic, strong) UIView *contentView;

@property (strong, nonatomic) UIView *buttonView;//titleLabel and otherButton's superView

// You can get buttons and labels for customizing their appearance
@property (nonatomic, strong) UIButton * cancelButton; // Default is in blue color and system font 14
@property (nonatomic, strong) UIButton * otherButton; // Default is in blue color and system font 14
@property (nonatomic, strong) UILabel *titleLabel; // Default is in black color and system bold font 15

// Set the height of title and button; and the padding of elements.
@property (nonatomic, assign) CGFloat buttonHeight; // Default is 44
@property (nonatomic, assign) CGFloat titleHeight; // Default is 44
@property (nonatomic, assign) CGFloat lineViewHeight; // Default is 1
@property (nonatomic, assign) CGFloat titleTopPadding; //Default is 0

// Customize the background and border
@property (nonatomic, strong) UIColor *borderColor; // Default is no border
@property (nonatomic, assign) CGFloat borderWidth; // Default is 0
@property (nonatomic, assign) CGFloat cornerRadius; // Default is 8

// Show the action sheet at current window
- (void)show;

// Hide the action sheet.
- (void)hide;

// Disable the button highlight by setting this property to NO
@property (nonatomic, assign) BOOL buttonClickedHighlight; //Default is YES

// The default color of dim background is black color with alpha 0.7
@property (nonatomic, assign) CGFloat dimAlpha;

// Set the text Color  and the font size of title. Default the text color is black, and font size is 15
- (void)setTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;

// Set the title color, background color and font size of button at index. Default the title color is black, background color is white and font size is 14.
- (void)setButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius backgroundImage:(UIImage *)backgroundImage atIndex:(int)index;

// Set the title color, background color and font size of cancel button. Default the ttitle color is black, background color is white and font size is 14.
- (void)setCancelButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius backgroundImage:(UIImage *)backgroundImage;

@end

@protocol MSActionSheetDelegate <NSObject>

@optional

- (void)actionSheetCancel:(MSActionsheet *)actionSheet;
- (void)actionSheet:(MSActionsheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex;
@end
