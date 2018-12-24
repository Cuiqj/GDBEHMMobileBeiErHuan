//
//  UICheckBoxButton.h
//  GDBEHMMobile
//
//  Created by xiaoxiaojia on 16/3/2.
//
//

#import <UIKit/UIKit.h>

@interface UICheckBoxButton : UIControl

{
    UILabel *label;
    UIImageView *icon;
    BOOL checked;
    id delegate;
}
@property (retain, nonatomic) id delegate;
@property (retain, nonatomic) UILabel *label;
@property (retain, nonatomic) UIImageView *icon;

-(BOOL)isChecked;
-(void)setChecked: (BOOL)flag;
@end
