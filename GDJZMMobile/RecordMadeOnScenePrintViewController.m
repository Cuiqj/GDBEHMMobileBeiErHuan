//
//  RecordMadeOnScenePrintViewController.m
//  GDBEHMMobile
//
//  Created by niexin on 12/2/13.
//
//


#import "RecordMadeOnScenePrintViewController.h"
#import "Citizen.h"
#import "CaseInquire.h"
#import "CaseInfo.h"
#import "CaseSpotRecord.h"
#import "CaseProveInfo.h"



@interface RecordMadeOnScenePrintViewController ()
@property(nonatomic,retain)Citizen *citizen;
@property(nonatomic,retain)CaseInquire *caseInquire;
@property(nonatomic,retain)CaseInfo *caseInfo;
@property(nonatomic,retain)CaseProveInfo *proveInfo;
@property(nonatomic,retain)CaseSpotRecord *caseSpotRecord;
@property (nonatomic,strong) UIPopoverController *pickerPopover;
@property (nonatomic,retain) UIPopoverController *citizenNamePicker;

@end


@implementation RecordMadeOnScenePrintViewController
@synthesize caseID = _caseID;
@synthesize citizen = _citizen;
@synthesize caseInquire = _caseInquire;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super setCaseID:self.caseID];      
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame = viewFrame;

    if (![self.caseID isEmpty]) {
        self.caseSpotRecord = [CaseSpotRecord spotRecordForCase:self.caseID];
        //CaseInquire和CaseProveInfo是生成默认的和加载现场笔录的时候都需要的对象
        self.caseInquire = [CaseInquire inquireForCase:self.caseID];
        self.proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if (self.caseSpotRecord) {
            [self pageLoadInfo];
        }else{
            [self generateCaseSpotRecord];
            [self pageLoadInfo];
        }
    }
    [super viewDidLoad];
	
}
- (void)generateDefaultAndLoad{
    [self generateCaseSpotRecord];
    [self pageLoadInfo];
}
//生成保存该文书的对象的内容
//如果已经存在该对象，则设置成默认的值，如果不存在，则设置成默认的值
-(void)generateCaseSpotRecord{
    
    //CaseInfo是生成CaseSpotRecord对象才需要用到的对象
    self.caseInfo = [CaseInfo caseInfoForID:self.caseID];
    
    self.caseSpotRecord = [CaseSpotRecord spotRecordForCase:self.caseID];
    if (!self.caseSpotRecord) {
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseSpotRecord" inManagedObjectContext:context];
        self.caseSpotRecord = [[CaseSpotRecord alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        self.caseSpotRecord.caseinfo_id = self.caseID;
    }


    



    
    
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
    NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
    
    
    //执法人员1名字
    self.caseSpotRecord.man1 = currentUserName;
    
    
    //执法人员2名字
    if([inspectorArray count] > 0 && [inspectorArray objectAtIndex:0]) {
        self.caseSpotRecord.man2 = [inspectorArray objectAtIndex:0];
    }
    
    
    //执法人员3名字
    if([inspectorArray count] > 1 && [inspectorArray objectAtIndex:1]) {
        self.caseSpotRecord.man3 = [inspectorArray objectAtIndex:1];
    }

    //记录人
    self.caseSpotRecord.recorder = self.caseInquire.recorder_name;
    
    
    
    //执法时间
    if (self.caseInfo && self.caseInfo.happen_date) {
        self.caseSpotRecord.time = self.caseInfo.happen_date;
    }
    
    
    if(self.proveInfo){
        //在检查中发现“内容”
        if (self.proveInfo.event_desc) {
            self.caseSpotRecord.content = [self.proveInfo.event_desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }else{
            self.caseSpotRecord.content = @"";
        }
        
        
        
        //执法地点
        self.caseSpotRecord.address = @"";
        if(self.proveInfo.remark){
            self.caseSpotRecord.address = [self.caseSpotRecord.address stringByAppendingString:self.proveInfo.remark];
        }
        if(self.caseInfo && self.caseInfo.full_station){
            self.caseSpotRecord.address = [self.caseSpotRecord.address stringByAppendingString:self.caseInfo.full_station];
        }
    }else{
        self.caseSpotRecord.content = @"";
        self.caseSpotRecord.address=@"";
    }

    [[AppDelegate App] saveContext];
}
//纯粹的数据加载
-(void)pageLoadInfo
{
    
    //执法地点
    if (![self.caseSpotRecord.address isEmpty] && self.caseSpotRecord.address != nil) {
        self.textLocation.text = self.caseSpotRecord.address;
    }else{
        self.textLocation.text = @"";
    }
    
    //在检查中发现“内容”
    if (self.caseSpotRecord.content) {
        self.textContent.text = self.caseSpotRecord.content;
    }else{
        self.textContent.text = @"";
    }
    
    
    //执法人员1名字
    if (self.caseSpotRecord.man1) {
        self.textEnforcerName1.text = self.caseSpotRecord.man1;
        self.textEnforcerNumber1.text = [UserInfo exelawIDForUserName:self.caseSpotRecord.man1];
    }
    
    //执法人员2名字
    if (self.caseSpotRecord.man2) {
        self.textEnforcerName2.text = self.caseSpotRecord.man2;
        self.textEnforcerNumber2.text = [UserInfo exelawIDForUserName:self.caseSpotRecord.man2];
    }
    
    //执法人员3名字
    if (self.caseSpotRecord.man3) {
        self.textEnforcerName3.text = self.caseSpotRecord.man3;
        self.textEnforcerNumber3.text = [UserInfo exelawIDForUserName:self.caseSpotRecord.man3];
    }
    
    //记录人
    if (self.caseSpotRecord.recorder) {
        self.textRecorderName.text = self.caseSpotRecord.recorder;
    }
    
    
    
    //执法时间
    if (self.caseSpotRecord.time) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:self.caseSpotRecord.time];
        NSArray * dateArr = [[NSArray alloc] initWithArray:[[strDate substringToIndex:10] componentsSeparatedByString:@"-"]];
        NSArray *timeArr = [[strDate substringFromIndex:10]componentsSeparatedByString:@":"];
        self.textEnforceYear.text = [dateArr objectAtIndex:0];
        self.textEnforceMonth.text = [dateArr objectAtIndex:1];
        self.textEnforceDay.text = [dateArr objectAtIndex:2];
        self.textEnforceHour.text = [timeArr objectAtIndex:0];
        self.textEnforceMinute.text = [timeArr objectAtIndex:1];
    }
    
    //备注
    if (self.caseSpotRecord.remark) {
        self.textRemark.text = self.caseSpotRecord.remark;
    }
    
    //现场人员基本情况
    self.citizen = [Citizen citizenByCitizenName:self.caseInquire.answerer_name nexus:self.caseInquire.relation case:self.caseID];
    if (self.citizen) {
        self.textSpoterName.text = self.citizen.party;
        self.textSpoterID.text = self.citizen.card_no;
        self.textSpoterCompanyAndDuty.text = [self.citizen.org_name stringByAppendingString:self.citizen.org_principal_duty];
        self.textSpoterAddress.text = self.citizen.address;
        self.textSpoterAutomobileNumber.text = self.citizen.automobile_number;
        self.textSpoterNexus.text = self.citizen.nexus;
        self.textSpoterPhoneNumber.text = self.citizen.tel_number;
        self.textSpoterAutomobilePattern.text = self.citizen.automobile_pattern;
    }
    

    //项目名称
    if (self.proveInfo && self.proveInfo.case_short_desc) {
        self.textSpoterProjectName.text = self.proveInfo.case_short_desc;
    }

    
}

-(void)pageSaveInfo
{
    
    self.caseSpotRecord = [CaseSpotRecord spotRecordForCase:self.caseID];
    
    self.caseSpotRecord.address = NSStringNilIsBad(self.textLocation.text);
    self.caseSpotRecord.man1 = NSStringNilIsBad(self.textEnforcerName1.text);
    self.caseSpotRecord.man2 = NSStringNilIsBad(self.textEnforcerName2.text);
    self.caseSpotRecord.man3 = NSStringNilIsBad(self.textEnforcerName3.text);
    self.caseSpotRecord.num1 = NSStringNilIsBad(self.textEnforcerNumber1.text);
    self.caseSpotRecord.num2 = NSStringNilIsBad(self.textEnforcerNumber2.text);
    self.caseSpotRecord.num3 = NSStringNilIsBad(self.textEnforcerNumber3.text);
    self.caseSpotRecord.recorder = NSStringNilIsBad(self.textRecorderName.text);
    self.caseSpotRecord.content = NSStringNilIsBad(self.textContent.text);
    self.caseSpotRecord.remark = NSStringNilIsBad(self.textRemark.text);
    
    if (self.textEnforceYear.text && self.textEnforceMonth.text && self.textEnforceDay.text && self.textEnforceHour.text && self.textEnforceMinute.text) {
        NSString *time = [NSString stringWithFormat:@"%@年%@月%@日%@时%@分",self.textEnforceYear.text,self.textEnforceMonth.text,self.textEnforceDay.text,self.textEnforceHour.text,self.textEnforceMinute.text];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        self.caseSpotRecord.time = [dateFormatter dateFromString:time];
    }
    
    [[AppDelegate App] saveContext];
}





- (NSString *)templateNameKey
{
    return DocNameKeyPei_XianChangBiLu;
}


- (id)dataForPDFTemplate
{
    NSString *year = @"";
    NSString *month = @"";
    NSString *day = @"";
    NSString *hour = @"";
    NSString *minute = @"";
    year = NSStringNilIsBad(self.textEnforceYear.text);
    month = NSStringNilIsBad(self.textEnforceMonth.text);
    day = NSStringNilIsBad(self.textEnforceDay.text);
    hour = NSStringNilIsBad(self.textEnforceHour.text);
    minute = NSStringNilIsBad(self.textEnforceMinute.text);
    id date = @{
                @"year": year,
                @"month":month,
                @"day": day,
                @"hour":hour,
                @"minute":minute
                };
    
    NSString *location = @"";
    NSString *enforcerName1 = @"";
    NSString *enforcerName2 = @"";
    NSString *enforcerName3 = @"";
    NSString *enforcerNumber1 = @"";
    NSString *enforcerNumber2 = @"";
    NSString *enforcerNumber3 = @"";
    NSString *enforceRecorder = @"";
    location = NSStringNilIsBad(self.textLocation.text);
    enforcerName1 = NSStringNilIsBad(self.textEnforcerName1.text);
    enforcerName2 = NSStringNilIsBad(self.textEnforcerName2.text);
    enforcerName3 = NSStringNilIsBad(self.textEnforcerName3.text);
    enforcerNumber1 = NSStringNilIsBad(self.textEnforcerNumber1.text);
    enforcerNumber2 = NSStringNilIsBad(self.textEnforcerNumber2.text);
    enforcerNumber3 = NSStringNilIsBad(self.textEnforcerNumber3.text);
    enforceRecorder = NSStringNilIsBad(self.textRecorderName.text);
    id recordData = @{
                      @"enforcerName1":enforcerName1,
                      @"enforcerName2":enforcerName2,
                      @"enforcerName3":enforcerName3,
                      @"enforcerNumber1":enforcerNumber1,
                      @"enforcerNumber2":enforcerNumber2,
                      @"enforcerNumber3":enforcerNumber3,
                      @"enforceRecorder":enforceRecorder
                      };
    
    NSString *spoterName = @"";
    NSString *spoterID = @"";
    NSString *spoterCompanyAndDuty = @"";
    NSString *spoterAddress = @"";
    NSString *spoterAutomobileNumber = @"";
    NSString *spoterProjectName = @"";
    NSString *spoterNexus = @"";
    NSString *spoterPhoneNumber = @"";
    NSString *spoterAutomobilePattern = @"";
    spoterName = NSStringNilIsBad(self.textSpoterName.text);
    spoterID = NSStringNilIsBad(self.textSpoterID.text);
    spoterCompanyAndDuty = NSStringNilIsBad(self.textSpoterCompanyAndDuty.text);
    spoterAddress = NSStringNilIsBad(self.textSpoterAddress.text);
    spoterAutomobileNumber = NSStringNilIsBad(self.textSpoterAutomobileNumber.text);
    spoterProjectName = NSStringNilIsBad(self.textSpoterProjectName.text);
    spoterNexus = NSStringNilIsBad(self.textSpoterNexus.text);
    spoterPhoneNumber = NSStringNilIsBad(self.textSpoterPhoneNumber.text);
    spoterAutomobilePattern = NSStringNilIsBad(self.textSpoterAutomobilePattern.text);
    id spoter = @{@"spoterName":spoterName,
                  @"spoterID":spoterID,
                  @"spoterCompanyAndDuty":spoterCompanyAndDuty,
                  @"spoterAddress":spoterAddress,
                  @"spoterAutomobileNumber":spoterAutomobileNumber,
                  @"spoterProjectName":spoterProjectName,
                  @"spoterNexus":spoterNexus,
                  @"spoterPhoneNumber":spoterPhoneNumber,
                  @"spoterAutomobilePattern":spoterAutomobilePattern
                  };
    NSString *content = @"";
    if (self.textContent.text) {
        content = [@"　　　　　　　　　　" stringByAppendingString:self.textContent.text];
    }
    NSString *remark = NSStringNilIsBad(self.textRemark.text);
    
    id data = @{
                @"location":location,
                @"recordData":recordData,
                @"date":date,
                @"spoter":spoter,
                @"content":content,
                @"remark":remark
                };
    
    return data;
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 114:
            return NO;
            break;
        default:
            return YES;
            break;
    }
}


- (IBAction)userSelected:(UITextField *)sender {
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
    if (self.textFieldTag == 111) {
        self.textEnforcerName1.text = name;
        self.textEnforcerNumber1.text = [UserInfo exelawIDForUserName:name];
    }else if (self.textFieldTag == 112){
        self.textEnforcerName2.text = name;
        self.textEnforcerNumber2.text = [UserInfo exelawIDForUserName:name];
    }else if (self.textFieldTag == 113){
        self.textEnforcerName3.text = name;
        self.textEnforcerNumber3.text = [UserInfo exelawIDForUserName:name];
    }else if (self.textFieldTag == 114){
        self.textRecorderName.text = name;
    }
}
    


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTextLocation:nil];
    [self setTextEnforceYear:nil];
    [self setTextEnforceMonth:nil];
    [self setTextEnforceDay:nil];
    [self setTextEnforceHour:nil];
    [self setTextEnforceMinute:nil];
    [self setTextEnforcerName1:nil];
    [self setTextEnforcerName2:nil];
    [self setTextEnforcerName3:nil];
    [self setTextEnforcerNumber1:nil];
    [self setTextEnforcerNumber2:nil];
    [self setTextEnforcerNumber3:nil];
    [self setTextRecorderName:nil];
    [self setTextSpoterName:nil];
    [self setTextSpoterID:nil];
    [self setTextSpoterCompanyAndDuty:nil];
    [self setTextSpoterAddress:nil];
    [self setTextSpoterAutomobileNumber:nil];
    [self setTextSpoterProjectName:nil];
    [self setTextSpoterNexus:nil];
    [self setTextSpoterPhoneNumber:nil];
    [self setTextSpoterAutomobilePattern:nil];
    [self setTextRemark:nil];
    [self setTextContent:nil];
    [super viewDidUnload];
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
    self.caseInquire = [CaseInquire inquireForCase:self.caseID withAnswererName:aAutoNumber];
    
    self.proveInfo = [CaseProveInfo proveInfoForCase:self.caseID withCitizenName:aAutoNumber];
    if(self.proveInfo == nil){
        self.proveInfo = [CaseProveInfo proveInfoForCase:self.caseID withInvitee:aAutoNumber];
    }
    if(self.proveInfo == nil){
        self.proveInfo = [CaseProveInfo proveInfoForCase:self.caseID withOrganizer:aAutoNumber];
    }

    [self pageLoadInfo];

}

@end
