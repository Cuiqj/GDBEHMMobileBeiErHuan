//
//  CaseProveInfoPrintViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseProveInfoPrintViewController.h"
#import "RoadSegment.h"
#import "UserInfo.h"
#import "CaseProveInfo.h"
#import "Citizen.h"
#import "CaseInfo.h"

static NSString * const xmlName = @"ProveInfoTable";

@interface CaseProveInfoPrintViewController ()
@property (nonatomic, retain) CaseProveInfo *caseProveInfo;
@property (nonatomic, retain) NSString *autoNumber;
@property (nonatomic,strong) UIPopoverController *pickerPopover;
@property (nonatomic,retain) UIPopoverController *citizenNamePicker;
@end

@implementation CaseProveInfoPrintViewController

@synthesize caseID = _caseID;

-(void)viewDidLoad{
    
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame = viewFrame;
    
    if (![self.caseID isEmpty]) {
        self.caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if(self.caseProveInfo){
            if (self.caseProveInfo.recorder == nil) {
                [self generateDefaultInfo:self.caseProveInfo];
            }
            [self pageLoadInfo];
        }
    }

    [super viewDidLoad];
    
    
    self.textstart_date_time.inputView = [[UIView alloc] init];
}

- (void)viewDidUnload
{
    [self setTextAge:nil];
    [self setTextPhoneNumber:nil];
    [self setTextAddress:nil];
    [self setTextDuty:nil];
    [self setTextprover3:nil];
    [self setTextprover3_duty:nil];
    [super viewDidUnload];
}



//根据案件记录，完整勘验信息
//既然是生成默认的信息
- (void)generateDefaultInfo:(CaseProveInfo *)caseProveInfo{
    caseProveInfo.end_date_time=[NSDate date];
    
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
    NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];

    

    NSString *inspectorName = currentUserName;
    for (NSString *name in inspectorArray) {
        if ([inspectorName isEmpty]) {
            inspectorName = name;
        } else {
            inspectorName = [inspectorName stringByAppendingFormat:@",%@",name];
        }
    }
    
    caseProveInfo.prover = inspectorName;
    caseProveInfo.recorder = currentUserName;
    Citizen *citizen = [self getCitizen];
    caseProveInfo.event_desc = [CaseProveInfo generateEventDescForCase:self.caseID withCitizen:citizen];
    [[AppDelegate App] saveContext];
}

- (void)generateDefaultAndLoad {
    [self generateDefaultInfo:self.caseProveInfo];
    [self pageLoadInfo];
}

//根据案件信息刷新勘验情况
- (IBAction)reFormEvetDesc:(UIButton *)sender {
    Citizen *citizen = [self getCitizen];
    self.textevent_desc.text = [CaseProveInfo generateEventDescForCase:self.caseID withCitizen:citizen];
    [self pageSaveInfo];
}



/*add by lxm
 *2013.05.02
 */
//该方法需要用到caseID为self.caseID的CaseInfo 和 self.caseProveInfo
- (void)pageLoadInfo
{
    
    if(self.caseProveInfo == nil) return;
    //案号
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    
    if(caseInfo){
        self.textMark2.text = caseInfo.case_mark2;
        self.textMark3.text = caseInfo.full_case_mark3;
    
        //天气情况
        self.textorganizer.text = caseInfo.weater;
    }
    

    //案由
    self.textcase_short_desc.text = self.caseProveInfo.case_short_desc;
    
    //勘验时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    if(self.caseProveInfo.start_date_time){
        self.textstart_date_time.text = [dateFormatter stringFromDate:self.caseProveInfo.start_date_time];
    }
    if(self.caseProveInfo.end_date_time){
        self.textend_date_time.text = [dateFormatter stringFromDate:self.caseProveInfo.end_date_time];
    }
    
    //勘验场所
    self.textprover_place.text = @"";
    if(self.caseProveInfo.remark){
        self.textprover_place.text = [self.textprover_place.text stringByAppendingString:self.caseProveInfo.remark];
    }
    if(caseInfo && caseInfo.full_station){
        self.textprover_place.text = [self.textprover_place.text stringByAppendingString:caseInfo.full_station];
    }
    
    NSArray *chunks = nil;
    if(self.caseProveInfo.prover){
        //分割字符串
        chunks = [self.caseProveInfo.prover componentsSeparatedByString: @","];
    }
    self.textprover1.text =@"";
    self.textprover1_duty.text = @"";
    self.textprover2.text = @"";
    self.textprover2_duty.text = @"";
    self.textprover3.text =@"";
    self.textprover3_duty.text = @"";
    
    
    if(chunks)
    {
        if([chunks count]>=1){
            //勘验人1 单位职务
            self.textprover1.text = [chunks objectAtIndex:0];
            self.textprover1_duty.text = [UserInfo orgAndDutyForUserName:[chunks objectAtIndex:0]];
        }
        if([chunks count]>=2){
            //勘验人2 单位职务
            self.textprover2.text = [chunks objectAtIndex:1];
            self.textprover2_duty.text = [UserInfo orgAndDutyForUserName:[chunks objectAtIndex:1]];
        }
        if([chunks count]>=3){
            //勘验人3 单位职务
            self.textprover3.text = [chunks objectAtIndex:2];
            self.textprover3_duty.text = [UserInfo orgAndDutyForUserName:[chunks objectAtIndex:2]];
        }
    }
    else
    {
        self.textprover1.text = self.caseProveInfo.prover;
        if (self.caseProveInfo.prover) {
            self.textprover1_duty.text = [UserInfo orgAndDutyForUserName:self.caseProveInfo.prover];
        }
        
        self.textprover2.text = self.caseProveInfo.secondProver;
        if ([self.caseProveInfo.secondProver length] > 0) {
            self.textprover2_duty.text = [UserInfo orgAndDutyForUserName:self.caseProveInfo.secondProver];
        }
    }
    
    if(self.caseProveInfo.citizen_name && [self.caseProveInfo.citizen_name length] > 0){
        //当事人(车牌号) 单位职务
        self.textcitizen_name.text = self.caseProveInfo.citizen_name;
        Citizen *citizen = [self getCitizen];
        if (citizen) {
            
            self.textcitizen_duty.text = citizen.org_name;
            
            self.caseProveInfo.organizer = citizen.sex;
            
            self.caseProveInfo.organizer_org_duty = citizen.card_no;
            
            //当事人年龄
            self.textAge.text = [citizen.age stringValue];
            
            //当事人联系电话
            self.textPhoneNumber.text = citizen.tel_number;
            
            //当事人地址
            self.textAddress.text = citizen.address;
            
            self.textDuty.text = citizen.org_principal_duty;
        }
    }
    
    //当事人性别
    
    self.textparty.text = [self.caseProveInfo.organizer length] > 0 ? self.caseProveInfo.organizer : @"";
    
    //当事人身份证号
    
    self.textparty_org_duty.text = [self.caseProveInfo.organizer_org_duty length] > 0? self.caseProveInfo.organizer_org_duty : @"";
    
    
    
    
    //被邀请人 单位职务
    self.textinvitee.text = [self.caseProveInfo.invitee length] > 0? self.caseProveInfo.invitee : @"";
    self.textInvitee_org_duty.text = [self.caseProveInfo.invitee_org_duty length] > 0 ? self.caseProveInfo.invitee_org_duty : @"";
    
    //记录人 单位职务
    if([self.caseProveInfo.recorder length] > 0){
        self.textrecorder.text =  self.caseProveInfo.recorder;
        self.textrecorder_duty.text = [UserInfo orgAndDutyForUserName:self.caseProveInfo.recorder];
    }
    
    //勘验情况及结果
    
    self.textevent_desc.text = [self.caseProveInfo.event_desc length] > 0 ? self.caseProveInfo.event_desc : @"";

    
}

- (void)pageSaveInfo
{
    
    if(self.caseProveInfo == nil){
        return;
    }
    //案由
    self.caseProveInfo.case_short_desc = self.textcase_short_desc.text;
    
    
    //勘验场所
    self.caseProveInfo.remark = self.textprover_place.text;
    
    //勘验人1 单位职务
    self.caseProveInfo.prover = @"";
    if(self.textprover1.text && [self.textprover1.text length] !=0 ){
        self.caseProveInfo.prover = [self.caseProveInfo.prover stringByAppendingString:self.textprover1.text];
    }
    if(self.textprover2.text && [self.textprover2.text length] !=0 ){
        if ([self.caseProveInfo.prover length] > 0) {
            self.caseProveInfo.prover =  [self.caseProveInfo.prover stringByAppendingString:@","];
        }
        self.caseProveInfo.prover = [self.caseProveInfo.prover stringByAppendingString:self.textprover2.text];
    }
    if(self.textprover3.text && [self.textprover3.text length] !=0 ){
        if ([self.caseProveInfo.prover length] > 0) {
           self.caseProveInfo.prover =  [self.caseProveInfo.prover stringByAppendingString:@","];
        }
        self.caseProveInfo.prover = [self.caseProveInfo.prover stringByAppendingString:self.textprover3.text];
    }
    
    
    
    //当事人 单位职务
    //先修改当事人的信息，后才修改勘验检查笔录中的人名
    Citizen *citizen = [self getCitizen];
    if (citizen) {
        citizen.party = self.textcitizen_name.text;
    }
    self.caseProveInfo.citizen_name = self.textcitizen_name.text;

    
    //当事人性别
    self.caseProveInfo.organizer  =   self.textparty.text ;
    
    //当事人身份证号
    self.caseProveInfo.organizer_org_duty  = self.textparty_org_duty.text;
    
    //被邀请人 单位职务
    self.caseProveInfo.invitee   =   self.textinvitee.text;
    self.caseProveInfo.invitee_org_duty = self.textInvitee_org_duty.text;
    
    //记录人 单位职务
    self.caseProveInfo.recorder = self.textrecorder.text;
    
    //勘验情况及结果
    self.caseProveInfo.event_desc = self.textevent_desc.text;
    
    // 更新
    CaseInfo* caseInfo = [CaseInfo caseInfoForID:self.caseID];
    caseInfo.happen_date = self.caseProveInfo.start_date_time;
    
    [[AppDelegate App] saveContext];
    
}




#pragma mark - prepare for Segue
//初始化各弹出选择页面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *segueIdentifier= [segue identifier];
    if ([segueIdentifier isEqualToString:@"toDateTimePicker"]) {
        DateSelectController *dsVC=segue.destinationViewController;
        dsVC.dateselectPopover=[(UIStoryboardPopoverSegue *) segue popoverController];
        dsVC.delegate=self;
        dsVC.pickerType=1;
        dsVC.textFieldTag = self.textstart_date_time.tag;
        dsVC.datePicker.maximumDate=[NSDate date];
        [dsVC showPastDate:self.caseProveInfo.start_date_time];
    }else if ([segueIdentifier isEqualToString:@"toDateTimePicker2"]) {
        DateSelectController *dsVC=segue.destinationViewController;
        dsVC.dateselectPopover=[(UIStoryboardPopoverSegue *) segue popoverController];
        dsVC.delegate=self;
        dsVC.pickerType=1;
        dsVC.textFieldTag = self.textend_date_time.tag;
        dsVC.datePicker.maximumDate=[NSDate date];
        [dsVC showPastDate:self.caseProveInfo.end_date_time];
    }
}

//时间选择
- (IBAction)selectDateAndTime:(id)sender
{
    [self dismissKeyboard];
    UITextField* textField = (UITextField* )sender;
    switch (textField.tag) {
        case 100:
            [self performSegueWithIdentifier:@"toDateTimePicker" sender:self];
            break;
        case 101:
            [self performSegueWithIdentifier:@"toDateTimePicker2" sender:self];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 100:
        case 101:
        case 200:
        case 201:
        case 202:
        case 203:{
            
            return NO;
            break;
        }
        default:
            return YES;
            break;
    }
}

- (void)setPastDate:(NSDate *)date withTag:(int)tag
{
    if (tag == self.textstart_date_time.tag) {
        self.caseProveInfo.start_date_time = date;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        self.textstart_date_time.text = [dateFormatter stringFromDate:self.caseProveInfo.start_date_time];
    }else if (tag == self.textend_date_time.tag) {
        self.caseProveInfo.end_date_time = date;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        self.textend_date_time.text = [dateFormatter stringFromDate:self.caseProveInfo.end_date_time];
    }
}

- (IBAction)userSelect:(UITextField *)sender {
    [self dismissKeyboard];
    self.textFieldTag = sender.tag;
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        UserPickerViewController *acPicker=[[UserPickerViewController alloc] init];
        acPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=self.pickerPopover;
    }
}

- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
    if (self.textFieldTag == 200) {
        self.textprover1.text = name;
        self.textprover1_duty.text = [UserInfo orgAndDutyForUserName:name];
    }else if (self.textFieldTag == 201){
        self.textprover2.text = name;
        self.textprover2_duty.text = [UserInfo orgAndDutyForUserName:name];
    }else if (self.textFieldTag == 202){
        self.textrecorder.text = name;
        self.textrecorder_duty.text = [UserInfo orgAndDutyForUserName:name];
    }else if (self.textFieldTag == 203){
        self.textprover3.text = name;
        self.textprover3_duty.text = [UserInfo orgAndDutyForUserName:name];
    }
}


//pdf相关
-(NSURL *)toFullPDFWithTable:(NSString *)filePath{
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:@"ProveInfoTable"];
        for (UITextView * aTextView in [self.view subviews]) {
            if ([aTextView isKindOfClass:[UITextView class]]) {
                [aTextView.text drawInRect:aTextView.frame withFont:aTextView.font];
            }
        }
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

-(NSURL *)toFullPDFWithPath_deprecated:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.caseProveInfo];
        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

-(NSURL *)toFormedPDFWithPath_deprecated:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawDateTable:xmlName withDataModel:self.caseProveInfo];
        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}
#pragma mark - CasePrintProtocol

- (NSString *)templateNameKey
{
    return DocNameKeyPei_AnJianKanYanJianChaBiLu;
}

- (id)dataForPDFTemplate
{
    id caseData = @{};
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        caseData = @{
                     @"mark2": caseInfo.case_mark2,
                     @"mark3": [NSString stringWithFormat:@"0%@",caseInfo.full_case_mark3],
                     @"weather": caseInfo.weater,
                     };
    }
    id caseProveData = @{};
    if (self.caseProveInfo) {
        NSString *sDateString = NSStringFromNSDateAndFormatter(self.caseProveInfo.start_date_time, NSDateFormatStringCustom1);
        NSString *eDateString = NSStringFromNSDateAndFormatter(self.caseProveInfo.end_date_time, NSDateFormatStringCustom1);
        id sDateData = DateDataFromDateString(sDateString);
        if (sDateData == nil) {
            sDateData = @{};
        }
        id eDateData = DateDataFromDateString(eDateString);
        if (eDateData == nil) {
            eDateData = @{};
        }
        
        id inspector1Data = @{};
        id inspector2Data = @{};
        id inspector3Data = @{};
        NSArray *inspectors = [self.caseProveInfo.prover componentsSeparatedByString: @","];
        for (int i = 0; i < inspectors.count; i++) {
            NSString *name = inspectors[i];
            name = (name == nil ? @"": name);
            NSString *org_duty = [UserInfo orgAndDutyForUserName:name];
            org_duty = (org_duty == nil ? @"": org_duty);
            NSString *userID = [UserInfo exelawIDForUserName:name];
            userID = (userID == nil ? @"":userID);
            if (i == 0) {
                inspector1Data = @{
                                   @"name": name,
                                   @"org_duty": org_duty,
                                   @"userID":userID
                                   };
            } else if (i == 1) {
                inspector2Data = @{
                                   @"name": name,
                                   @"org_duty": org_duty,
                                   @"userID":userID
                                   };
            }else if (i == 2) {
                inspector3Data = @{
                                   @"name": name,
                                   @"org_duty": org_duty,
                                   @"userID":userID
                                   };
            }
        }
        id partyData = [@{} mutableCopy];
        if (self.caseProveInfo.citizen_name != nil) {
            [partyData setObject:self.caseProveInfo.citizen_name forKey:@"name"];
        }
        if (self.textparty_org_duty != nil) {
            [partyData setObject:self.textparty_org_duty.text forKey:@"id"];
        }
        Citizen *citizen = [self getCitizen];

        if (citizen) {
            NSString *citizen_org_duty = [NSString stringWithFormat:@"%@%@", citizen.org_name, citizen.org_principal_duty];
            [partyData setObject:citizen_org_duty forKey:@"org_duty"];
        }
        
        
        id attorneyData = [@{} mutableCopy];
        if (self.caseProveInfo.organizer != nil) {
            if ([self.caseProveInfo.organizer isEqualToString:@"无"]) {
                [attorneyData setObject:@"" forKey:@"name"];
            }else
            {
                [attorneyData setObject:self.caseProveInfo.organizer forKey:@"name"];
            }
        }
        if (self.caseProveInfo.organizer_org_duty != nil) {
            
            if ([self.caseProveInfo.organizer_org_duty isEqualToString:@"无"]) {
                [attorneyData setObject:@"" forKey:@"org_duty"];
            }else
            {
                [attorneyData setObject:self.caseProveInfo.organizer_org_duty forKey:@"org_duty"];
            }
            
        }
        
        id inviteeData = [@{} mutableCopy];
        if (self.caseProveInfo.invitee != nil) {
            [inviteeData setObject:self.caseProveInfo.invitee forKey:@"name"];
        }
        if (self.caseProveInfo.invitee_org_duty != nil) {
            [inviteeData setObject:self.caseProveInfo.invitee_org_duty forKey:@"org_duty"];
        }
        
        id recorderData = [@{} mutableCopy];
        if (self.caseProveInfo.recorder != nil) {
            [recorderData setObject:self.caseProveInfo.recorder forKey:@"name"];
        }
        if (self.caseProveInfo.recorder_org_duty != nil) {
            [recorderData setObject:self.caseProveInfo.recorder_org_duty forKey:@"org_duty"];
        }
        
        id inspect_resultData = @"";
        if (self.caseProveInfo.event_desc != nil) {
            inspect_resultData = [NSString stringWithFormat:@"\b\b%@",self.caseProveInfo.event_desc];
        }
        NSString *sex = NSStringNilIsBad(self.caseProveInfo.organizer);
        NSString *age = NSStringNilIsBad(self.textAge.text);
        NSString *telephone = NSStringNilIsBad(self.textPhoneNumber.text);
        NSString *address = NSStringNilIsBad(self.textAddress.text);
        NSString *org = NSStringNilIsBad(self.textcitizen_duty.text);
        NSString *duty = NSStringNilIsBad(self.textDuty.text);
        NSString *remark = NSStringNilIsBad(self.caseProveInfo.remark);
        caseProveData = @{
                          @"description": self.caseProveInfo.case_short_desc,
                          @"sDate": sDateData,
                          @"eDate": eDateData,
                          @"inpect_place": remark,
                          @"inspector1": inspector1Data,
                          @"inspector2": inspector2Data,
                          @"inspector3": inspector3Data,
                          @"party": partyData,
                          @"attorney": attorneyData,
                          @"invitee": inviteeData,
                          @"recorder": recorderData,
                          @"inspect_result": inspect_resultData,
                          @"sex":sex,
                          @"duty":duty,
                          @"age":age,
                          @"telephone":telephone,
                          @"address":address,
                          @"org":org
                          };
    }
    
    id data = @{
                @"case": caseData,
                @"caseProve": caseProveData,
                };
    return data;
    
}
//多车辆中的选择车辆  选中多车辆中的对应的当事人
- (IBAction)showCitizenNamePicker:(id)sender{
    if (([self.citizenNamePicker isPopoverVisible])) {
        [self.citizenNamePicker dismissPopoverAnimated:YES];
    } else {
        AutoNumerPickerViewController *pickerVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AutoNumberPicker"];
        pickerVC.delegate=self;
        pickerVC.caseID=_caseID;
        pickerVC.pickerType=kCarOwnerName;
        self.citizenNamePicker=[[UIPopoverController alloc] initWithContentViewController:pickerVC];
        [self.citizenNamePicker presentPopoverFromRect:[(UITextField*)sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
}
-(void)setAutoNumberText:(NSString *)aAutoNumber{
    [self.citizenNamePicker dismissPopoverAnimated:YES];
    self.caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID withCitizenName:aAutoNumber];
    if(self.caseProveInfo){
        if (self.caseProveInfo.recorder == nil) {
            [self generateDefaultInfo:self.caseProveInfo];
        }
        [self pageLoadInfo];
    }
    
}

-(Citizen*)getCitizen{
    Citizen *citizen = [Citizen citizenByCitizenName:self.caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
    if(citizen == nil){
        citizen = [Citizen citizenByCitizenName:self.caseProveInfo.citizen_name nexus:@"当事人代表" case:self.caseID];
        if(citizen == nil){
            citizen = [Citizen citizenByCitizenName:self.caseProveInfo.citizen_name nexus:@"被邀请人" case:self.caseID];
        }
    }
    return citizen;
}
@end
