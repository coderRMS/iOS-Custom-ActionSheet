//
//  MSActionsheet.m
//  MSActionsheetDemo
//
//  Created by 阮明森 on 16/2/1.
//  Copyright © 2016年 rms. All rights reserved.
//

#import "MSActionsheet.h"

#define MARGIN_LEFT 15
#define MARGIN_RIGHT 15
#define SPACE_SMALL 5
#define TITLE_FONT_SIZE 15
#define BUTTON_FONT_SIZE 14
#define CANCELBUTTON_FONT_SIZE 14
#define DEFAULT_LINEVIEW_BGCOLOR [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]

@interface MSActionsheet ()



@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *buttonTitleArray;

@end

CGFloat contentViewWidth;
CGFloat contentViewHeight;

@implementation MSActionsheet

- (id)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _title = title;
        _delegate = delegate;
        _cancelButtonTitle = cancelButtonTitle;
        
        // Initialization code
        
        self.clipsToBounds = YES;
        self.cornerRadius = 8;
        self.buttonClickedHighlight = YES;
        self.buttonHeight = 44;
        self.titleTopPadding = 0;
        self.titleHeight = 44;
        self.lineViewHeight = 1;
        self.dimAlpha = 0.7;

        _buttonArray = [NSMutableArray array];
        _buttonTitleArray = [NSMutableArray array];
        
        va_list args;
        va_start(args, otherButtonTitles);
        if (otherButtonTitles) {
            [_buttonTitleArray addObject:otherButtonTitles];
            while (1) {
                NSString *otherButtonTitle = va_arg(args, NSString *);
                if (otherButtonTitle == nil) {
                    break;
                } else {
                    [_buttonTitleArray addObject:otherButtonTitle];
                }
            }
        }
        va_end(args);
        
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.alpha = 0;
        _backgroundView.backgroundColor = [UIColor blackColor];
        [_backgroundView addGestureRecognizer:tapGestureRecognizer];
        [self addSubview:_backgroundView];
        
        [self initContentView];
    }
    return self;
}

- (void)initContentView {
    contentViewWidth = self.frame.size.width - MARGIN_LEFT - MARGIN_RIGHT;
    contentViewHeight = 0;
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    
    _buttonView = [[UIView alloc] init];
    _buttonView.backgroundColor = [UIColor whiteColor];
    
    [self initTitle];
    [self initButtons];
    [self initCancelButton];
    
    _contentView.frame = CGRectMake((self.frame.size.width - contentViewWidth ) / 2, self.frame.size.height, contentViewWidth, contentViewHeight);
    [self addSubview:_contentView];
}

- (void)initTitle {
    if (_title != nil && ![_title isEqualToString:@""]) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleTopPadding, contentViewWidth, _titleHeight)];
        _titleLabel.text = _title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [_buttonView addSubview:_titleLabel];
        contentViewHeight += _titleHeight + _titleTopPadding;
    }
}

- (void)initButtons {
    if (_buttonTitleArray.count > 0) {
        NSInteger count = _buttonTitleArray.count;
        for (int i = 0; i < count; i++) {
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, contentViewHeight, contentViewWidth, _lineViewHeight)];
            [lineView setBackgroundColor:DEFAULT_LINEVIEW_BGCOLOR];
            
            [_buttonView addSubview:lineView];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, contentViewHeight + _lineViewHeight, contentViewWidth, _buttonHeight)];
            button.backgroundColor = [UIColor whiteColor];
            button.titleLabel.font = [UIFont systemFontOfSize:BUTTON_FONT_SIZE];
            [button setTitle:_buttonTitleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1.0] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonArray addObject:button];
            [_buttonView addSubview:button];
            contentViewHeight += lineView.frame.size.height + button.frame.size.height;
        }
        _buttonView.frame = CGRectMake(0, 0, contentViewWidth, contentViewHeight);
        _buttonView.layer.cornerRadius = _cornerRadius;
        _buttonView.layer.masksToBounds = YES;
        [_contentView addSubview:_buttonView];
    }
}

- (void)initCancelButton {
    if (_cancelButtonTitle != nil) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, contentViewHeight + SPACE_SMALL, contentViewWidth, 44)];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:CANCELBUTTON_FONT_SIZE];
        _cancelButton.layer.cornerRadius = _cornerRadius;
        [_cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cancelButton];
        contentViewHeight += SPACE_SMALL + _cancelButton.frame.size.height + SPACE_SMALL;
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self initContentView];
}

- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle {
    _cancelButtonTitle = cancelButtonTitle;
    [_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:self];
    [self addAnimation];
}

- (void)hide {
    [self removeAnimation];
}

- (void)setTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius{
    if (color != nil) {
        _titleLabel.textColor = color;
    }
    
    if (bgcolor != nil) {
        [_titleLabel setBackgroundColor:bgcolor];
    }
    
    if (size > 0) {
        _titleLabel.font = [UIFont systemFontOfSize:size];
    }
    
    if (borderColor != nil) {
        _titleLabel.layer.borderColor = borderColor.CGColor;
    }
    
    if (borderWidth > 0) {
        _titleLabel.layer.borderWidth = borderWidth;
    }
    
    if (cornerRadius > 0) {
        _titleLabel.layer.cornerRadius = cornerRadius;
    }

}

- (void)setButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius backgroundImage:(UIImage *)backgroundImage atIndex:(int)index {
   
    UIButton *button = _buttonArray[index];
    if (color != nil) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (bgcolor != nil) {
        [button setBackgroundColor:bgcolor];
    }
    
    if (size > 0) {
        button.titleLabel.font = [UIFont systemFontOfSize:size];
    }
    
    if (borderColor != nil) {
        button.layer.borderColor = borderColor.CGColor;
    }
    
    if (borderWidth > 0) {
        button.layer.borderWidth = borderWidth;
    }
    
    if (cornerRadius > 0) {
        button.layer.cornerRadius = cornerRadius;
    }
    
    if (backgroundImage != nil) {
        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }

}

- (void)setCancelButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius backgroundImage:(UIImage *)backgroundImage{
    if (color != nil) {
        [_cancelButton setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (bgcolor != nil) {
        [_cancelButton setBackgroundColor:bgcolor];
    }
    
    if (size > 0) {
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:size];
    }
    
    if (borderColor != nil) {
        _cancelButton.layer.borderColor = borderColor.CGColor;
    }
    
    if (borderWidth > 0) {
        _cancelButton.layer.borderWidth = borderWidth;
    }
    
    if (cornerRadius > 0) {
        _cancelButton.layer.cornerRadius = cornerRadius;
    }
    
    if (backgroundImage != nil) {
        [_cancelButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
}

- (void)addAnimation {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, self.frame.size.height - _contentView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height);
        _backgroundView.alpha = _dimAlpha;
    } completion:^(BOOL finished) {
    }];
}

- (void)removeAnimation {
    [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, self.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height);
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)buttonPressed:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonIndex:)]) {
        for (int i = 0; i < _buttonArray.count; i++) {
            if (button == _buttonArray[i]) {
                
                if (self.buttonClickedHighlight)
                {
                    UIColor * originColor = [button.backgroundColor colorWithAlphaComponent:0];
                    button.backgroundColor = [button.backgroundColor colorWithAlphaComponent:.1];
                    double delayInSeconds = .2;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        button.backgroundColor = originColor;
                    });
                }
                [_delegate actionSheet:self clickedButtonIndex:i];
                break;
            }
        }
    }
    [self hide];
}

- (void)cancelButtonPressed:(UIButton *)button {
    
    if (self.buttonClickedHighlight)
    {
        UIColor * originColor = [self.cancelButton.backgroundColor colorWithAlphaComponent:0];
        self.cancelButton.backgroundColor = [self.cancelButton.backgroundColor colorWithAlphaComponent:.1];
        double delayInSeconds = .2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.cancelButton.backgroundColor = originColor;
        });
        
    }
    if (_delegate && [_delegate respondsToSelector:@selector(actionSheetCancel:)]) {
        [_delegate actionSheetCancel:self];
    }
    [self hide];
}


@end
