//
//  AddNewInspectRecordViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddNewInspectRecordViewController.h"
#import "Global.h"
#import "RoadInspectViewController.h"
#import "UserPickerViewController.h"

@interface AddNewInspectRecordViewController ()
@property (nonatomic,retain) NSString *roadSegmentID;

- (void)keyboardWillHide:(NSNotification *)aNotification;

@property (nonatomic, assign) BOOL isStartTime;
@property (weak, nonatomic) UIView *addStreetLampView;
@property (weak, nonatomic) UIView *addControlBoxView;
@property (weak, nonatomic) UIView *addLogView;
@end

@implementation AddNewInspectRecordViewController
@synthesize contentView;
@synthesize textCheckType;
@synthesize textCheckReason;
@synthesize textCheckHandle;
@synthesize textCheckStatus;
@synthesize textSide;
//@synthesize textWeather;
@synthesize textDate;
@synthesize textSegement;
//@synthesize textSide;
@synthesize textPlace;
@synthesize textStationStartKM;
@synthesize textStationStartM;
@synthesize viewNormalDesc;
@synthesize textTimeStart;
//@synthesize textTimeEnd;
@synthesize textRoad;
@synthesize textPlaceNormal;
@synthesize textDescNormal;
@synthesize textViewNormalDesc;
@synthesize descState;
@synthesize isStartTime;
@synthesize addStreetLampView;
@synthesize addControlBoxView;
@synthesize addLogView;
@synthesize addStreetLampBtn;
@synthesize addControlBoxBtn;
@synthesize addLogBtn;
@synthesize touchTextTag;
//@synthesize textStationEndKM;
//@synthesize textStationEndM;

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.contentView setDelaysContentTouches:NO];
    self.descState = kAddNewRecord;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //西二环南段版本 不需要两个按钮
    [self.btnAddCounstructionChangeBack setHidden:YES];
    [self.btnAddTrafficRecord setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    if (self.descState == kAddNewRecord) {
        [self.contentView setContentSize:self.contentView.frame.size];
    }
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    if (self.descState == kAddNewRecord) {
        [self.contentView setContentSize:CGSizeMake(self.contentView.frame.size.width,self.contentView.frame.size.height+200)];
    }
}


- (void)viewDidUnload
{
    [self setTextCheckType:nil];
    [self setTextCheckReason:nil];
    [self setTextCheckHandle:nil];
    [self setTextCheckStatus:nil];
    [self setPickerPopover:nil];
    [self setCheckTypeID:nil];
    //    [self setTextWeather:nil];
    [self setTextDate:nil];
    [self setTextSegement:nil];
    [self setTextPlace:nil];
    [self setTextStationStartKM:nil];
    [self setTextStationStartM:nil];
    //    [self setTextStationEndKM:nil];
    //    [self setTextStationEndM:nil];
    [self setRoadSegmentID:nil];
    [self setContentView:nil];
    [self setViewNormalDesc:nil];
    [self setTextTimeStart:nil];
//    [self setTextTimeEnd:nil];
    [self setTextRoad:nil];
    [self setTextPlaceNormal:nil];
    [self setTextDescNormal:nil];
    [self setTextViewNormalDesc:nil];
    [self setTextSide:nil];
    [self setBtnAddTrafficRecord:nil];
    [self setBtnAddCounstructionChangeBack:nil];
    [self setAddStreetLampBtn:nil];
    [self setAddControlBoxBtn:nil];
    [self setAddLogBtn:nil];
	[self setAddLogBtn:nil];
	[self setAddControlBoxBtn:nil];
	[self setAddStreetLampBtn:nil];
	[self setAddStreetLampBtn:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)btnSwitch:(UIButton *)sender {
    if (self.descState != kNormalDesc) {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.uibuttonSwitch setTitle:@"返回" forState:UIControlStateNormal];
                             [self.uibuttonSwitch setTitle:@"返回" forState:UIControlStateHighlighted];
                             [self.addStreetLampBtn setTitle:@"路灯" forState:UIControlStateNormal];
                             [self.addStreetLampBtn setTitle:@"路灯" forState:UIControlStateHighlighted];
                             [self.addLogBtn setTitle:@"日志" forState:UIControlStateNormal];
                             [self.addLogBtn setTitle:@"日志" forState:UIControlStateHighlighted];
                             [self.addLogView removeFromSuperview];
                             [self.addStreetLampView removeFromSuperview];
                             [self.addControlBoxView removeFromSuperview];
                             [self.viewNormalDesc setHidden:NO];
                             [self.view bringSubviewToFront:self.viewNormalDesc];
                             [self.contentView setHidden:YES];
                         }
                         completion:nil];
        self.descState = kNormalDesc;
    } else {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateNormal];
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateHighlighted];
                             [self.contentView setHidden:NO];
                             [self.addLogView removeFromSuperview];
                             [self.addStreetLampView removeFromSuperview];
                             [self.addControlBoxView removeFromSuperview];
                             [self.view bringSubviewToFront:self.contentView];
                             [self.viewNormalDesc setHidden:YES];
                         }
                         completion:nil];
        self.isStartTime = YES;
        self.descState = kAddNewRecord;
    }
}

- (IBAction)btnDismiss:(id)sender {
    [self.delegate addObserverToKeyBoard];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnSave:(id)sender {
    if (self.descState == kAddNewRecord) {
        BOOL isBlank =NO;
//        for (id obj in self.contentView.subviews) {
//            if ([obj isKindOfClass:[UITextField class]]) {
//                if ([[(UITextField *)obj text] isEmpty]) {
//                    
//                    if ([obj tag] < 111 ) {
//                        isBlank=YES;
//                    }
//                }
//            }
//        }
        if ([self.textDate.text isEmpty]
            || [self.textStationStartM.text isEmpty]
            || [self.textSide.text isEmpty]
            || [self.textStationStartKM.text isEmpty]
            || [self.textCheckType.text isEmpty]
            || [self.textSegement.text isEmpty]
            || [self.textPlace.text isEmpty]
            ) {
            isBlank=YES;
        }
        if (!isBlank) {
            InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
            inspectionRecord.roadsegment_id=[NSString stringWithFormat:@"%d", [self.roadSegmentID intValue]];
            inspectionRecord.fix=self.textSide.text;
            inspectionRecord.inspection_type=self.textCheckType.text;
            inspectionRecord.inspection_item=self.textCheckReason.text;
            inspectionRecord.location=self.textPlace.text;
            inspectionRecord.measure=self.textCheckHandle.text;
            inspectionRecord.status=self.textCheckStatus.text;
            inspectionRecord.inspection_id=self.inspectionID;
            inspectionRecord.relationid = @"0";
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            inspectionRecord.start_time=[dateFormatter dateFromString:self.textDate.text];
            
            [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
            NSString *timeString=[dateFormatter stringFromDate:inspectionRecord.start_time];
            NSString *remark=[[NSString alloc] initWithFormat:@"%@  巡至%@%@K%d+%03d处时，在公路%@%@，巡逻班组%@。",timeString,self.textSegement.text,self.textSide.text,self.textStationStartKM.text.integerValue,self.textStationStartM.text.integerValue,self.textPlace.text,self.textCheckReason.text,self.textCheckStatus.text];
            self.textCheckHandle.text=[self.textCheckHandle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (![self.textCheckHandle.text isEmpty]) {
                remark=[remark stringByAppendingFormat:@"%@。",self.textCheckHandle.text];
            }
            inspectionRecord.station=@(self.textStationStartKM.text.integerValue*1000+self.textStationStartM.text.integerValue);
            inspectionRecord.remark=remark;
            [[AppDelegate App] saveContext];
            [self.delegate reloadRecordData];
            [self.delegate addObserverToKeyBoard];
            [self dismissModalViewControllerAnimated:YES];
        }
    } else if(self.descState == kAddStreetLamp){
        [self saveRecordLight];
    }else if(self.descState == KAddLog) {
        [self saveRecordLog];
    }else if(self.descState == KAddControlBox){
        [self saveRecordHDControl];
    }else{
        BOOL isBlank =NO;
        for (id obj in self.viewNormalDesc.subviews) {
            if ([obj isKindOfClass:[UITextField class]]) {
                if ([[(UITextField *)obj text] isEmpty]) {
                    isBlank=YES;
                }
            }
        }
        if (!isBlank) {
            if ([self.textViewNormalDesc.text isEmpty]) {
                self.textViewNormalDesc.text = [NSString stringWithFormat:@"%@，巡查%@%@，%@",self.textTimeStart.text,self.textRoad.text,self.textPlaceNormal.text,self.textDescNormal.text];
            }
            InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
            inspectionRecord.roadsegment_id=[NSString stringWithFormat:@"%d", [self.roadSegmentID intValue]];
            inspectionRecord.fix=self.textPlaceNormal.text;
            inspectionRecord.inspection_type=@"日常巡查";
            inspectionRecord.inspection_item= @"无异常";
            inspectionRecord.location=self.textPlaceNormal.text;
            inspectionRecord.measure=@"";
            inspectionRecord.status=@"";
            inspectionRecord.inspection_id=self.inspectionID;
            inspectionRecord.relationid = @"0";
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
            inspectionRecord.start_time = [dateFormatter dateFromString:self.textTimeStart.text];
            inspectionRecord.remark=self.textViewNormalDesc.text;
            [[AppDelegate App] saveContext];
            [self.delegate reloadRecordData];
            [self.delegate addObserverToKeyBoard];
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

//弹窗
- (void)pickerPresentPickerState:(InspectionCheckState)state fromRect:(CGRect)rect{
    if ((state==self.pickerState) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.pickerState=state;
        InspectionCheckPickerViewController *icPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"InspectionCheckPicker"];
        icPicker.pickerState=state;
        icPicker.checkTypeID=self.checkTypeID;
        icPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        if (self.descState == kAddNewRecord) {
            rect = [self.view convertRect:rect fromView:self.contentView];
        } else {
            rect = [self.view convertRect:rect fromView:self.viewNormalDesc];
        }
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        icPicker.pickerPopover=self.pickerPopover;
    }
}

//路段选择弹窗
- (void)roadSegmentPickerPresentPickerState:(RoadSegmentPickerState)state fromRect:(CGRect)rect{
    if ((state==self.roadSegmentPickerState) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.roadSegmentPickerState=state;
        RoadSegmentPickerViewController *icPicker=[[RoadSegmentPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        icPicker.tableView.frame=CGRectMake(0, 0, 150, 243);
        icPicker.pickerState=state;
        icPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(150, 243)];
        if (self.descState == kAddNewRecord) {
            rect = [self.view convertRect:rect fromView:self.contentView];
        } else {
            rect = [self.view convertRect:rect fromView:self.viewNormalDesc];
        }
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover=self.pickerPopover;
    }
}

- (IBAction)textTouch:(UITextField *)sender {
    switch (sender.tag) {
        case 100:{
            //时间选择
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate=self;
                datePicker.pickerType=1;
                [datePicker showdate:self.textDate.text];
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
                CGRect rect;
                if (self.descState == kAddNewRecord) {
                    rect = [self.view convertRect:sender.frame fromView:self.contentView];
                } else {
                    rect = [self.view convertRect:sender.frame fromView:self.viewNormalDesc];
                }
                [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover=self.pickerPopover;
            }
        }
            break;
        case 102:
            [self roadSegmentPickerPresentPickerState:kRoadSegment fromRect:sender.frame];
            break;
        case 103:
            [self roadSegmentPickerPresentPickerState:kRoadSide fromRect:sender.frame];
            break;
        case 104:
            [self roadSegmentPickerPresentPickerState:kRoadPlace fromRect:sender.frame];
            break;
        case 109:
            [self pickerPresentPickerState:kCheckType fromRect:sender.frame];
            break;
        case 110:
            [self pickerPresentPickerState:kCheckReason fromRect:sender.frame];
            break;
        case 111:
            [self pickerPresentPickerState:kCheckStatus fromRect:sender.frame];
            break;
        case 112:
            [self pickerPresentPickerState:kCheckHandle fromRect:sender.frame];
            break;
        case 300:
            [self pickerPresentPickerState:kCarCode fromRect:sender.frame];
            break;
        case 200:
            [self pickerPresentPickerState:kWorkShifts fromRect:sender.frame];
            break;
        default:
            break;
    }
}

- (IBAction)toCaseView:(id)sender {
    //UIViewController *caseView = [self.storyboard instantiateViewControllerWithIdentifier:@"CaseView"];
    [self.delegate addObserverToKeyBoard];
    [self dismissModalViewControllerAnimated:YES];
    [((RoadInspectViewController*)self.delegate) performSegueWithIdentifier:@"inspectToCaseView" sender:self];
}

#pragma mark - Delegate Implement

- (void)setCheckType:(NSString *)typeName typeID:(NSString *)typeID{
    self.checkTypeID=typeID;
    self.textCheckType.text=typeName;
}

- (void)setCheckText:(NSString *)checkText{
    UITextField *textField;
    switch (self.pickerState) {
        case kCheckStatus:
            self.textCheckStatus.text=checkText;
            break;
        case kCheckHandle:
            self.textCheckHandle.text=checkText;
            break;
        case kCheckReason:
            self.textCheckReason.text=checkText;
            break;
        case kDescription:
            self.textDescNormal.text = checkText;
            break;
        case kCarCode:
            textField= (UITextField*)[addLogView viewWithTag:300];
            textField.text = checkText;
            break;
        case kWorkShifts:
            textField=(UITextField*)[addLogView viewWithTag:200];
            textField.text = checkText;
            break;
        default:
            break;
    }
}

- (void)setDate:(NSString *)date{
    if (self.descState == kAddNewRecord) {
        self.textDate.text=date;
    } if(self.descState == KAddControlBox){
        UITextField *check_date = (UITextField*)[addControlBoxView viewWithTag:100];//检查日期
        check_date.text = date;
    }if(self.descState == kAddStreetLamp){
        UITextField *check_date=(UITextField*)[addStreetLampView viewWithTag:100];
        check_date.text = date;
    }if(self.descState == KAddLog){
        UITextField *record_date=(UITextField*)[addLogView viewWithTag:100];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *temp=[dateFormatter dateFromString:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString=[dateFormatter stringFromDate:temp];
        record_date.text = dateString;
    }else {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *temp=[dateFormatter dateFromString:date];
        [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
        NSString *dateString=[dateFormatter stringFromDate:temp];
        if (self.isStartTime) { self.textTimeStart.text = dateString;}
        //else { self.textTimeEnd.text = dateString;}
    }
}

- (void)setRoadSegment:(NSString *)aRoadSegmentID roadName:(NSString *)roadName{
    if (self.descState == kAddNewRecord) {
        self.roadSegmentID=aRoadSegmentID;
        self.textSegement.text=roadName;
    } else {
        self.roadSegmentID = aRoadSegmentID;
        self.textRoad.text = roadName;
    }
}

- (void)setRoad:(NSString *)aRoadID roadName:(NSString *)roadName{
    if (self.descState == kAddNewRecord) {
        self.roadSegmentID=aRoadID;
        self.textSegement.text=roadName;
    } else {
        self.roadSegmentID = aRoadID;
        self.textRoad.text = roadName;
    }
}

- (void)setRoadPlace:(NSString *)place{
    if (self.descState == kAddNewRecord) {
        NSString *places = self.textPlace.text;

        if(![places isEmpty]){
            NSArray *placeArray =[places componentsSeparatedByString:@"、"];
            for(NSString *p in placeArray){
                if([[p stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet] ]isEqualToString:place]){
                    return;
                }
            }
            places = [places stringByAppendingString:@"、"];
        }
        self.textPlace.text = [places stringByAppendingString:place];

    }
}

- (void)setRoadSide:(NSString *)side{
    if (self.descState == kAddNewRecord) {
        self.textSide.text = side;
    } else {
        self.textPlaceNormal.text = side;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==100 || textField.tag == 1001 || textField.tag == 1002) {
        return NO;
    } else
        return YES;
}

- (IBAction)btnFormNormalDesc:(id)sender {
    self.textViewNormalDesc.text = [NSString stringWithFormat:@"%@，巡查%@%@，%@",self.textTimeStart.text,self.textRoad.text,self.textPlaceNormal.text,self.textDescNormal.text];
}

- (IBAction)viewNormalTextTouch:(UITextField *)sender {
    if (sender.tag == 1001) {
        self.isStartTime = YES;
    }
    if (sender.tag == 1002) {
        self.isStartTime = NO;
    }
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
        datePicker.delegate=self;
        datePicker.pickerType=1;
        if (self.isStartTime) {
            [datePicker showdate:self.textTimeStart.text];
        } else {
            //[datePicker showdate:self.textTimeEnd.text];
        }
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
        CGRect rect;
        if (self.descState == kAddNewRecord) {
            rect = [self.view convertRect:sender.frame fromView:self.contentView];
        } else {
            rect = [self.view convertRect:sender.frame fromView:self.viewNormalDesc];
        }
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        datePicker.dateselectPopover=self.pickerPopover;
    }
}

- (IBAction)viewNormalRoadTouch:(id)sender {
    if ([sender tag] == 1003) {
        [self roadSegmentPickerPresentPickerState:kRoadSegment fromRect:[(UITextField *)sender frame]];
    }
    if ([sender tag] == 1004) {
        [self roadSegmentPickerPresentPickerState:kRoadSide fromRect:[(UITextField *)sender frame]];
    }
}

- (IBAction)pickerNormalDesc:(id)sender {
    [self pickerPresentPickerState:kDescription fromRect:[(UITextField *)sender frame]];    
}

- (IBAction)addCounstructionChangeBack:(id)sender {
    [self.delegate addObserverToKeyBoard];
    [self dismissViewControllerAnimated:YES completion:^{
        [((RoadInspectViewController*)self.delegate) performSegueWithIdentifier:@"toCounstructionChangeBack" sender:self];
    }];
}

- (IBAction)addTrafficRecord:(id)sender {
    [self.delegate addObserverToKeyBoard];
    [self dismissViewControllerAnimated:YES completion:^{
        [((RoadInspectViewController*)self.delegate) performSegueWithIdentifier:@"toTrafficRecord" sender:self];
    }];
}

- (IBAction)addStreetLamp:(id)sender {
    if (self.descState != kAddStreetLamp) {
        if(addStreetLampView == nil){
            UIViewController *controller =[self.storyboard instantiateViewControllerWithIdentifier:@"streetLampInspection"];
            controller.view.frame = CGRectMake( 0,44, self.viewNormalDesc.frame.size.width, self.viewNormalDesc.frame.size.height );
            addStreetLampView = controller.view;
            [self.view addSubview:addStreetLampView];
            UITextView *eastStreetLamp=(UITextView*)[addStreetLampView viewWithTag:1];
            eastStreetLamp.layer.borderColor = [UIColor grayColor].CGColor;
            eastStreetLamp.layer.borderWidth =1.0;
            eastStreetLamp.layer.cornerRadius =5.0;
            UITextView *westStreetLamp=(UITextView*)[addStreetLampView viewWithTag:2];
            westStreetLamp.layer.borderColor = [UIColor grayColor].CGColor;
            westStreetLamp.layer.borderWidth =1.0;
            westStreetLamp.layer.cornerRadius =5.0;
            UITextView *otherStreetLamp=(UITextView*)[addStreetLampView viewWithTag:3];
            otherStreetLamp.layer.borderColor = [UIColor grayColor].CGColor;
            otherStreetLamp.layer.borderWidth =1.0;
            otherStreetLamp.layer.cornerRadius =5.0;
            UITextView *boxTransformer=(UITextView*)[addStreetLampView viewWithTag:4];
            boxTransformer.layer.borderColor = [UIColor grayColor].CGColor;
            boxTransformer.layer.borderWidth =1.0;
            boxTransformer.layer.cornerRadius =5.0;
            UITextView *streetLampDescription=(UITextView*)[addStreetLampView viewWithTag:5];
            streetLampDescription.layer.borderColor = [UIColor grayColor].CGColor;
            streetLampDescription.layer.borderWidth =1.0;
            streetLampDescription.layer.cornerRadius =5.0;
            
            UITextField *check_date=(UITextField*)[addStreetLampView viewWithTag:100];
            [check_date addTarget:self action:@selector(textTouch:) forControlEvents:UIControlEventTouchDown];
        }
        [self reloadRecordLight];

        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.addStreetLampBtn setTitle:@"返回" forState:UIControlStateNormal];
                             [self.addStreetLampBtn setTitle:@"返回" forState:UIControlStateHighlighted];
                             [self.addLogBtn setTitle:@"日志" forState:UIControlStateNormal];
                             [self.addLogBtn setTitle:@"日志" forState:UIControlStateHighlighted];
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateNormal];
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateHighlighted];
                             [self.addControlBoxBtn setTitle:@"控制箱" forState:UIControlStateNormal];
                             [self.addControlBoxBtn setTitle:@"控制箱" forState:UIControlStateHighlighted];
                             [self.viewNormalDesc setHidden:YES];
                             [self.addControlBoxView removeFromSuperview];
                             [self.addLogView removeFromSuperview];
                             [self.view insertSubview:self.addStreetLampView atIndex:3];
                             [self.contentView setHidden:YES];
                         }
                         completion:nil];
        
        self.descState = kAddStreetLamp;
    } else {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.addStreetLampBtn setTitle:@"路灯" forState:UIControlStateNormal];
                             [self.addStreetLampBtn setTitle:@"路灯" forState:UIControlStateHighlighted];
                             [self.contentView setHidden:NO];
                             [self.addControlBoxView removeFromSuperview];
                             [self.addLogView removeFromSuperview];
                             [self.addStreetLampView removeFromSuperview];
                             [self.view bringSubviewToFront:self.contentView];
                             [self.viewNormalDesc setHidden:YES];
                         }
                         completion:nil];
        self.descState = kAddNewRecord;
    }

}

- (IBAction)addControlBox:(id)sender {
    if (self.descState != KAddControlBox) {
        if(addControlBoxView == nil){
            UIViewController *controller =[self.storyboard instantiateViewControllerWithIdentifier:@"controlbox"];
            controller.view.frame = CGRectMake( 0,44, self.viewNormalDesc.frame.size.width, self.viewNormalDesc.frame.size.height );
            addControlBoxView = controller.view;
            [self.view addSubview:addControlBoxView];
            UITextView *note_desc=(UITextView*)[addControlBoxView viewWithTag:3];
            note_desc.layer.borderColor = [UIColor grayColor].CGColor;
            note_desc.layer.borderWidth =1.0;
            note_desc.layer.cornerRadius =5.0;
            UITextView *remark=(UITextView*)[addControlBoxView viewWithTag:4];
            remark.layer.borderColor = [UIColor grayColor].CGColor;
            remark.layer.borderWidth =1.0;
            remark.layer.cornerRadius =5.0;
            
            UITextView *east=(UITextView*)[addControlBoxView viewWithTag:1];
            east.layer.borderColor = [UIColor grayColor].CGColor;
            east.layer.borderWidth =1.0;
            east.layer.cornerRadius =5.0;
            UITextView *west=(UITextView*)[addControlBoxView viewWithTag:2];
            west.layer.borderColor = [UIColor grayColor].CGColor;
            west.layer.borderWidth =1.0;
            west.layer.cornerRadius =5.0;
            
            UITextField *check_date=(UITextField*)[addControlBoxView viewWithTag:100];
            [check_date addTarget:self action:@selector(textTouch:) forControlEvents:UIControlEventTouchDown];
        }
        
        [self reloadRecordHDConctrol];
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.addControlBoxBtn setTitle:@"返回" forState:UIControlStateNormal];
                             [self.addControlBoxBtn setTitle:@"返回" forState:UIControlStateHighlighted];
                             [self.addLogBtn setTitle:@"日志" forState:UIControlStateNormal];
                             [self.addLogBtn setTitle:@"日志" forState:UIControlStateHighlighted];
                             [self.addStreetLampBtn setTitle:@"路灯" forState:UIControlStateNormal];
                             [self.addStreetLampBtn setTitle:@"路灯" forState:UIControlStateHighlighted];
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateNormal];
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateHighlighted];
                             [self.viewNormalDesc setHidden:YES];
                             [self.addLogView removeFromSuperview];
                             [self.addStreetLampView removeFromSuperview];
                             [self.view insertSubview:self.addControlBoxView atIndex:3];
                             [self.contentView setHidden:YES];
                         }
                         completion:nil];
        
        self.descState = KAddControlBox;
    } else {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.addControlBoxBtn setTitle:@"控制箱" forState:UIControlStateNormal];
                             [self.addControlBoxBtn setTitle:@"控制箱" forState:UIControlStateHighlighted];
                             [self.contentView setHidden:NO];
                             [self.addControlBoxView removeFromSuperview];
                             [self.addLogView removeFromSuperview];
                             [self.addStreetLampView removeFromSuperview];
                             [self.view bringSubviewToFront:self.contentView];
                             [self.viewNormalDesc setHidden:YES];
                         }
                         completion:nil];
        self.descState = kAddNewRecord;
    }
}

- (IBAction)addLog:(id)sender {
    if (self.descState != KAddLog) {
        if(addLogView == nil){
            UIViewController *controller =[self.storyboard instantiateViewControllerWithIdentifier:@"pdanotes"];
            controller.view.frame = CGRectMake( 0,44, self.viewNormalDesc.frame.size.width, self.viewNormalDesc.frame.size.height );
            addLogView = controller.view;
            [self.view addSubview:addLogView];
            UITextView *note_desc=(UITextView*)[addLogView viewWithTag:5];
            note_desc.layer.borderColor = [UIColor grayColor].CGColor;
            note_desc.layer.borderWidth =1.0;
            note_desc.layer.cornerRadius =5.0;
            UITextView *remark=(UITextView*)[addLogView viewWithTag:6];
            remark.layer.borderColor = [UIColor grayColor].CGColor;
            remark.layer.borderWidth =1.0;
            remark.layer.cornerRadius =5.0;
        }

        [self reloadRecordLog];
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.addLogBtn setTitle:@"返回" forState:UIControlStateNormal];
                             [self.addLogBtn setTitle:@"返回" forState:UIControlStateHighlighted];
                             [self.addStreetLampBtn setTitle:@"路灯" forState:UIControlStateNormal];
                             [self.addStreetLampBtn setTitle:@"路灯" forState:UIControlStateHighlighted];
                             [self.addControlBoxBtn setTitle:@"控制箱" forState:UIControlStateNormal];
                             [self.addControlBoxBtn setTitle:@"控制箱" forState:UIControlStateHighlighted];
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateNormal];
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateHighlighted];
                             [self.viewNormalDesc setHidden:YES];
                             [self.addControlBoxView removeFromSuperview];
                             [self.addStreetLampView removeFromSuperview];
                             [self.view insertSubview:self.addLogView atIndex:3];
                             [self.contentView setHidden:YES];
                         }
                         completion:nil];
        
        self.descState = KAddLog;
    } else {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.addLogBtn setTitle:@"日志" forState:UIControlStateNormal];
                             [self.addLogBtn setTitle:@"日志" forState:UIControlStateHighlighted];
                             [self.addControlBoxBtn setTitle:@"控制箱" forState:UIControlStateNormal];
                             [self.addControlBoxBtn setTitle:@"控制箱" forState:UIControlStateHighlighted];
                             [self.contentView setHidden:NO];
                             [self.addControlBoxView removeFromSuperview];
                             [self.addLogView removeFromSuperview];
                             [self.addStreetLampView removeFromSuperview];
                             [self.view bringSubviewToFront:self.contentView];
                             [self.viewNormalDesc setHidden:YES];
                         }
                         completion:nil];
        self.descState = kAddNewRecord;
    }
}
- (void)saveRecordLight{
    NSString * inspectionID = [[NSUserDefaults standardUserDefaults] stringForKey:INSPECTIONKEY];
    NSArray *lights =[InspectionLight inspectionLightForID:inspectionID];
    InspectionLight *light;
    if([lights count] > 0){
        light = [lights objectAtIndex:0];
    }else{
        light=[InspectionLight newDataObjectWithEntityName:@"InspectionLight"];
        light.inspectionid = inspectionID;
    }
    UITextField *check_date = (UITextField*)[addStreetLampView viewWithTag:100];//检查日期
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    light.check_date = [dateFormatter dateFromString:check_date.text];
    
    UITextView *mainlight_east = (UITextView*)[addStreetLampView viewWithTag:1];//主线路灯东行
    light.mainlight_east = mainlight_east.text;
    
    UITextView *mainlight_west = (UITextView*)[addStreetLampView viewWithTag:2];//主线路灯西行
    light.mainlight_west = mainlight_west.text;
    
    UITextView *otherlight = (UITextView*)[addStreetLampView viewWithTag:3];//其他路灯情况
    light.otherlight = otherlight.text;
    
    
    UITextView *box = (UITextView*)[addStreetLampView viewWithTag:4];//箱变情况
    light.box = box.text;
    
    UITextView *remark = (UITextView*)[addStreetLampView viewWithTag:5];//备注
    light.remark = remark.text;
    [[AppDelegate App] saveContext];
}
- (void)reloadRecordLight{
    NSString * inspectionID = [[NSUserDefaults standardUserDefaults] stringForKey:INSPECTIONKEY];
    NSArray *lights =[InspectionLight inspectionLightForID:inspectionID];
    if([lights count] > 0){
        InspectionLight *light = [lights objectAtIndex:0];
    
        UITextField *check_date = (UITextField*)[addStreetLampView viewWithTag:100];//检查日期
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        check_date.text = [dateFormatter stringFromDate:light.check_date];
    
        UITextView *mainlight_east = (UITextView*)[addStreetLampView viewWithTag:1];//主线路灯东行
        mainlight_east.text = light.mainlight_east;
    
        UITextView *mainlight_west = (UITextView*)[addStreetLampView viewWithTag:2];//主线路灯西行
        mainlight_west.text = light.mainlight_west;
    
        UITextView *otherlight = (UITextView*)[addStreetLampView viewWithTag:3];//其他路灯情况
        otherlight.text = light.otherlight;
    
    
        UITextView *box = (UITextView*)[addStreetLampView viewWithTag:4];//箱变情况
        box.text = light.box;
    
        UITextView *remark = (UITextView*)[addStreetLampView viewWithTag:5];//备注
        remark.text = light.remark;
        
    }else{
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        UITextField *check_date = (UITextField*)[addStreetLampView viewWithTag:100];//检查日期
        check_date.text = [dateFormatter stringFromDate:[NSDate date]];;
    }

}

- (void)saveRecordLog{
    UITextField *classe=(UITextField*)[addLogView viewWithTag:200];
    [classe addTarget:self action:@selector(textTouch:) forControlEvents:UIControlEventTouchDown];
    
    UITextField *carname=(UITextField*)[addLogView viewWithTag:300];
    [carname addTarget:self action:@selector(textTouch:) forControlEvents:UIControlEventTouchDown];
    
    UITextField *record_date=(UITextField*)[addLogView viewWithTag:100];
    [record_date addTarget:self action:@selector(textTouch:) forControlEvents:UIControlEventTouchDown];
    
    UITextField *recorder=(UITextField*)[addLogView viewWithTag:4];
    [recorder addTarget:self action:@selector(userSelect:) forControlEvents:UIControlEventTouchDown];
    
    UITextView *note_desc=(UITextView*)[addLogView viewWithTag:5];
    UITextView *remark=(UITextView*)[addLogView viewWithTag:6];
    NSString * inspectionID = [[NSUserDefaults standardUserDefaults] stringForKey:INSPECTIONKEY];
    NSArray *inspections = [Inspection inspectionForID:inspectionID];
    Pdanotes *note;
    if([inspections count] > 0){
        Inspection *inspection =(Inspection*) [inspections objectAtIndex:0];
        NSArray *notes =[Pdanotes getNowPdanotes:inspection.classe carCode:inspection.carcode];
        if([notes count] > 0){
            note = [notes objectAtIndex:0];
            note.classe = classe.text;
            note.carname = carname.text;
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            note.record_date = [dateFormatter dateFromString:record_date.text];
            note.recorder = recorder.text;
            note.note_desc = note_desc.text;
            note.remark = remark.text;
        }else{
            note=[Pdanotes newDataObjectWithEntityName:@"Pdanotes"];
            note.classe = classe.text;
            note.carname = carname.text;
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            note.record_date = [dateFormatter dateFromString:record_date.text];
            note.recorder = recorder.text;
            note.note_desc = note_desc.text;
            note.remark = remark.text;
        }
    }
    
    [[AppDelegate App] saveContext];
}
- (void)reloadRecordLog{
    UITextField *classe=(UITextField*)[addLogView viewWithTag:200];
    [classe addTarget:self action:@selector(textTouch:) forControlEvents:UIControlEventTouchDown];
    
    UITextField *carname=(UITextField*)[addLogView viewWithTag:300];
    [carname addTarget:self action:@selector(textTouch:) forControlEvents:UIControlEventTouchDown];
    
    UITextField *record_date=(UITextField*)[addLogView viewWithTag:100];
    [record_date addTarget:self action:@selector(textTouch:) forControlEvents:UIControlEventTouchDown];
    
    UITextField *recorder=(UITextField*)[addLogView viewWithTag:4];
    [recorder addTarget:self action:@selector(userSelect:) forControlEvents:UIControlEventTouchDown];
    
    UITextView *note_desc=(UITextView*)[addLogView viewWithTag:5];
    UITextView *remark=(UITextView*)[addLogView viewWithTag:6];
    
    NSString * inspectionID = [[NSUserDefaults standardUserDefaults] stringForKey:INSPECTIONKEY];
    NSArray *inspections = [Inspection inspectionForID:inspectionID];
    if([inspections count] > 0){
        Inspection *inspection =(Inspection*) [inspections objectAtIndex:0];
        NSArray *notes =[Pdanotes getNowPdanotes:inspection.classe carCode:inspection.carcode];
        if([notes count] > 0){
            Pdanotes *note = [notes objectAtIndex:0];
            classe.text = note.classe;
            carname.text = note.carname;
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            record_date.text = [dateFormatter stringFromDate:note.record_date];
            recorder.text = note.recorder;
            note_desc.text = note.note_desc;
            remark.text = note.remark;
            return;
            
        }
    }
    if([inspections count] > 0){
        Inspection *inspection =(Inspection*) [inspections objectAtIndex:0];
        classe.text = inspection.classe;
        carname.text = inspection.carcode;
        
    }
    [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    record_date.text = [dateFormatter stringFromDate:[NSDate date]];
    
    
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
    NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
    if (inspectorArray.count < 1) {
        recorder.text = currentUserName;
    } else {
        NSString *inspectorName = @"";
        for (NSString *name in inspectorArray) {
            if ([inspectorName isEmpty]) {
                inspectorName = name;
            } else {
                inspectorName = [inspectorName stringByAppendingFormat:@",%@",name];
            }
        }
        recorder.text = inspectorName;
        
    }

    
}
- (void)reloadRecordHDConctrol{
    UITextField *mainHD_east=(UITextField*)[addControlBoxView viewWithTag:1];
       
    UITextField *mianHD_west=(UITextField*)[addControlBoxView viewWithTag:2];

    
    UITextView *mainstatus=(UITextView*)[addControlBoxView viewWithTag:3];
    UITextView *solution=(UITextView*)[addControlBoxView viewWithTag:4];
    
    NSString * inspectionID = [[NSUserDefaults standardUserDefaults] stringForKey:INSPECTIONKEY];
    NSArray *inspectionHDControls = [InspectionHDControl InspectionHDControlForID:inspectionID];
    if([inspectionHDControls count] > 0){
        InspectionHDControl *inspectionHDControl = [inspectionHDControls objectAtIndex:0];
        
        UITextField *check_date = (UITextField*)[addControlBoxView viewWithTag:100];//检查日期
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        check_date.text = [dateFormatter stringFromDate:inspectionHDControl.checkdate];
        
        mainHD_east.text = inspectionHDControl.mainHD_east;
        mianHD_west.text = inspectionHDControl.mianHD_west;
        mainstatus.text = inspectionHDControl.mainstatus;
        solution.text = inspectionHDControl.solution;
        
    }else{
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        UITextField *check_date = (UITextField*)[addControlBoxView viewWithTag:100];//检查日期
        check_date.text = [dateFormatter stringFromDate:[NSDate date]];;
    }
    
    
}

- (void)saveRecordHDControl{
    NSString * inspectionID = [[NSUserDefaults standardUserDefaults] stringForKey:INSPECTIONKEY];
    NSArray *inspectionHDControls =[InspectionHDControl InspectionHDControlForID:inspectionID];
    InspectionHDControl *inspectionHDControl;
    if([inspectionHDControls count] > 0){
        inspectionHDControl = [inspectionHDControls objectAtIndex:0];
    }else{
        inspectionHDControl=[InspectionHDControl newDataObjectWithEntityName:@"InspectionHDControl"];
        inspectionHDControl.inspectionid = inspectionID;
    }
    UITextField *check_date = (UITextField*)[addControlBoxView viewWithTag:100];//检查日期
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    inspectionHDControl.checkdate = [dateFormatter dateFromString:check_date.text];
    
    UITextView *mainHD_east = (UITextView*)[addControlBoxView viewWithTag:1];
    inspectionHDControl.mainHD_east = mainHD_east.text;
    
    UITextView *mianHD_west = (UITextView*)[addControlBoxView viewWithTag:2];
    inspectionHDControl.mianHD_west = mianHD_west.text;
    
    
    UITextView *mainstatus = (UITextView*)[addControlBoxView viewWithTag:3];
    inspectionHDControl.mainstatus = mainstatus.text;
    
    UITextView *solution = (UITextView*)[addControlBoxView viewWithTag:4];
    inspectionHDControl.solution = solution.text;
    [[AppDelegate App] saveContext];
}
- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
    UITextField *recorder=(UITextField*)[addLogView viewWithTag:4];
    if(![recorder.text isEmpty]){
        recorder.text = [recorder.text stringByAppendingFormat:@"%@%@",@"、",name];
    }else{
        recorder.text = name;
    }
}
//选择操作员
- (IBAction)userSelect:(UITextField *)sender {
    if ((self.touchTextTag == sender.tag) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
        UserPickerViewController *acPicker=[[UserPickerViewController alloc] init];
        acPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=self.pickerPopover;
    }
}

@end
