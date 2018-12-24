//
//  CaseInquirePrinterViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-9.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "CasePrintViewController.h"
#import "CaseInquire.h"
#import "CaseInfo.h"
#import "UserPickerViewController.h"
#import "DateSelectController.h"
#import "AnswererPickerViewController.h"
#import "AutoNumerPickerViewController.h"

@interface CaseInquirePrinterViewController : CasePrintViewController <DatetimePickerHandler,UserPickerDelegate,UITextViewDelegate,setAnswererDelegate,AutoNumberPickerDelegate>

//add by lxm 2013.05.10
@property(nonatomic,weak)IBOutlet UITextField *textdate_inquired;       //  时间
@property(nonatomic,weak)IBOutlet UITextField *textlocality;            //地点
@property(nonatomic,weak)IBOutlet UITextField *textinquirer_name;       //  询问人

@property(nonatomic,weak)IBOutlet UITextField *textrecorder_name;   //记录人

@property(nonatomic,weak)IBOutlet UITextField *textanswerer_name;   //被询问人

@property(nonatomic,weak)IBOutlet UITextField *textsex;     //身份证号
@property(nonatomic,weak)IBOutlet UITextField *textage;

@property(nonatomic,weak)IBOutlet UITextField *textrelation;        //与案件关系

@property(nonatomic,weak)IBOutlet UITextField *textcompany_duty;    //工作单位和职务

@property(nonatomic,weak)IBOutlet UITextField *textphone;       //  电话

@property(nonatomic,weak)IBOutlet UITextField *textaddress;     //详细地址

@property(nonatomic,weak)IBOutlet UITextField *textpostalcode;  //邮编

@property(nonatomic,weak)IBOutlet UITextView *textinquiry_note;     //  询问笔录详情

@property (weak, nonatomic) IBOutlet UILabel * inquireNotequestionone;
//4个答案
@property (weak, nonatomic) IBOutlet UITextView *textQuestion1;
@property (weak, nonatomic) IBOutlet UITextView *textQuestion2;
@property (weak, nonatomic) IBOutlet UITextView *textQuestion3;
@property (weak, nonatomic) IBOutlet UITextView *textQuestion4;



@property (nonatomic, assign) int textFieldTag;

- (IBAction)selectDateAndTime:(id)sender;

- (IBAction)showCitizenNamePicker:(id)sender;




@end
