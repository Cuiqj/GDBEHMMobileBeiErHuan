//
//  CaseParkingNodePrintViewController.m
//  GDXERHMMobile
//
//  Created by XU SHIWEN on 13-9-3.
//
//责令车辆停驶通知书

#import "CaseParkingNodePrintViewController.h"
#import "CaseInfo.h"
#import "Citizen.h"
#import "RoadSegment.h"
#import "ParkingNode.h"
#import "CaseProveInfo.h"
#import "Systype.h"
#import "OrgInfo.h"
#import "UserInfo.h"
#import "AutoNumerPickerViewController.h"

typedef enum _kTextFieldTag {
    kTextFieldTagCitizenName = 0x10,
    kTextFieldTagHappenDate,
    kTextFieldTagAutoMobileNumber,
    kTextFieldTagPlacePrefix,
    kTextFieldTagStationStart,
    kTextFieldTagCaseShortDescription,
    kTextFieldTagParkingNodeAddress,
    kTextFieldTagPeriodLimit,
    kTextFieldTagOfficeAddress
} kTextFieldTag;

@interface CaseParkingNodePrintViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UIPopoverController *pickerPopover;
@property (nonatomic,retain) UIPopoverController *autoNumberPicker;

@end

@implementation CaseParkingNodePrintViewController   

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCaseID:self.caseID];
    [self assignTagsToUIControl];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,946, 1000);
    [self pageLoadInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextFieldCitizenName:nil];
    [self setTextFieldHappenDate:nil];
    [self setTextFieldAutomobileNumber:nil];
    [self setTextFieldPlacePrefix:nil];
    [self setTextFieldStationStart:nil];
    [self setTextFieldCaseShortDescription:nil];
    [self setTextFieldParkingNodeAddress:nil];
    [self setTextFieldPeriodLimit:nil];
    [self setTextFieldOfficeAddress:nil];
    [self setLabelSendDate:nil];
    [self setTextCarNumber:nil];
    [self setTextLabelType:nil];
    [self setTextCarOwnerName:nil];
    [self setTextCarOwnerAddress:nil];
    [self setTextCarOwnerOrgName:nil];
    [self setTextCarOwnerOrgAddress:nil];
    [self setTextCitizenName:nil];
    [self setTextCitizenDNo:nil];
    [self setTextCitizenAddress:nil];
    [self setTextRelation:nil];
    [self setTextDateStart:nil];
    [self setTextParkingAddress:nil];
    [self setTextPrintDate:nil];
    [self setTextEnforcerName1:nil];
    [self setTextEnforcerName2:nil];
    [self setTextEnforcerName3:nil];
    [self setTextEnforcerNumber1:nil];
    [self setTextEnforcerNumber2:nil];
    [self setTextEnforcerNumber3:nil];
    [super viewDidUnload];
}


- (void)assignTagsToUIControl
{
    self.textFieldCitizenName.tag = kTextFieldTagCitizenName;
    self.textFieldHappenDate.tag = kTextFieldTagHappenDate;
    self.textFieldAutomobileNumber.tag = kTextFieldTagAutoMobileNumber;
    self.textFieldPlacePrefix.tag = kTextFieldTagPlacePrefix;
    self.textFieldStationStart.tag = kTextFieldTagStationStart;
    self.textFieldCaseShortDescription.tag = kTextFieldTagCaseShortDescription;
    self.textFieldParkingNodeAddress.tag = kTextFieldTagParkingNodeAddress;
    self.textFieldPeriodLimit.tag = kTextFieldTagPeriodLimit;
    self.textFieldOfficeAddress.tag = kTextFieldTagOfficeAddress;
}



#pragma mark - Methods from superclass
- (void)pageLoadInfo{
//    Citizen * citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
//    if (citizen.party.length >0) {
//         [self pageLoadInfo:citizen.party];
//    }else{
         [self pageLoadInfo:nil];
//    }
  
}
- (void)pageLoadInfo:(NSString*)citizenName
{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        ParkingNode * parkingNode = nil;
        if(citizenName){
            parkingNode = [ParkingNode parkingNodesForCase:self.caseID withCitizenName:citizenName];
        }else{
            parkingNode = [ParkingNode parkingNodesForCase:self.caseID];
        }
        
        Citizen *citizen = [Citizen citizenByAutomobileNumber:parkingNode.citizen_name withNexus:@"当事人" withCase:self.caseID];
        if(!citizen){
            citizen = [Citizen citizenByAutomobileNumber:parkingNode.citizen_name withNexus:@"被邀请人" withCase:self.caseID];
            if(!citizen){
                citizen = [Citizen citizenByAutomobileNumber:parkingNode.citizen_name withNexus:@"当事人代表" withCase:self.caseID];
            }
        }
        if (citizen)
        {
            //车主姓名
            if (citizen.automobile_owner && [self.textCarOwnerName.text isEmpty]) {
                self.textCarOwnerName.text = citizen.automobile_owner;
            }
            if ([citizen.nexus isEqualToString:@"当事人"]) {
                self.textCarOwnerName.text = citizen.party;
            }
            
            //车主住址
            if (citizen.carowner_address) {
                self.textCarOwnerAddress.text = citizen.carowner_address;
            }
            
            
            //车辆驾驶人姓名
            if (citizen.party) {
                self.textCitizenName.text = citizen.party;
            }
            
            //驾驶人住址
            if (citizen.carowner_address) {
                self.textCitizenAddress.text = citizen.address;
            }
            
            //与车辆所有人关系
            if (citizen.nexus) {
                self.textRelation.text = citizen.nexus;
            }
            
            //车牌号码
            if (![citizen.automobile_number isEmpty] && parkingNode) {
                parkingNode.citizen_name = citizen.automobile_number;
            }
            self.textCarNumber.text = NSStringNilIsBad(parkingNode.citizen_name);
            self.textFieldAutomobileNumber.text = self.textCarNumber.text;

        }
        //厂牌型号
        if (parkingNode.fNo) {
            self.textLabelType.text = parkingNode.fNo;
        }
        
        //车辆驾驶人驾驶证号
        if (parkingNode.dNo) {
            self.textCitizenDNo.text = parkingNode.dNo;
        }
        
        //单位名称
        if (parkingNode.ownerorg) {
            self.textCarOwnerOrgName.text = parkingNode.ownerorg;
        }
        
        //单位地址
        if (parkingNode.ownerorgaddress) {
            self.textCarOwnerOrgAddress.text = parkingNode.ownerorgaddress;
        }
        
        //责令停止时间
        if (caseInfo.happen_date && !parkingNode.date_start) {
            parkingNode.date_start = caseInfo.happen_date;
            //把date_start显示在textField中
            
        }
        NSDate *startDate = parkingNode.date_start;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        self.textDateStart.text = [dateFormatter stringFromDate:startDate];
        
        //最下面打印时间
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        self.textPrintDate.text = [dateFormatter stringFromDate:[NSDate date]];
        
        
        
        //停驶地点
        if (parkingNode.address) {
            self.textParkingAddress.text = parkingNode.address;
            self.textFieldParkingNodeAddress.text = parkingNode.address;
        }
        
        
//        //在某某公路
//        RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
//        if (roadSegment) {
//            [self.textFieldPlacePrefix  setText:roadSegment.place_prefix1];
//        }
//        
//        //某某处
//        [self.textFieldStationStart setText:[caseInfo fullCaseMarkAfterK:NO]];
        
        if (![parkingNode.happenplace isEmpty] && parkingNode.happenplace) {
            NSArray *roadAndStation = [parkingNode.happenplace componentsSeparatedByString:@"----"];
            if (roadAndStation.count >= 2) {
                self.textFieldPlacePrefix.text = [roadAndStation objectAtIndex:0];
                self.textFieldStationStart.text = [roadAndStation objectAtIndex:1];
            }
        }else{
            //在某某公路
            RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
            if (roadSegment) {
                [self.textFieldPlacePrefix  setText:roadSegment.place_prefix1];
            }
            
            //某某处
            [self.textFieldStationStart setText:[caseInfo fullCaseMarkAfterK:NO]];
        }
        
        
        
        
        
        
        //停驶期限
        NSArray *typeValues = [Systype typeValueForCodeName:@"停驶期限"];
        if (typeValues.count > 0) {
            NSString *typeValue = typeValues[0];
            [self.textFieldPeriodLimit setText:typeValue];
        } else {
            [self.textFieldPeriodLimit setText:@"七"];
        }
        
        //处理单位
        OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
        if (orgInfo.orgshortname) {
            [self.textFieldOfficeAddress setText:orgInfo.orgshortname];
        }
        
        //接受处理机关地址
        if (orgInfo.orgname) {
            if ([orgInfo.orgname hasSuffix:@"（K22处）"]) {
                self.TextFieldHandleAddress.text = orgInfo.orgname;
            }else
            self.TextFieldHandleAddress.text = [orgInfo.orgname stringByAppendingFormat:@"（K22处）"];
        }
        
        //联系电话
        if (![orgInfo.telephone isEmpty]) {
            self.TextFieldTelePhone.text = orgInfo.telephone;
        }else if (![parkingNode.telephone isEmpty])
            self.TextFieldTelePhone.text = parkingNode.telephone;
        else{
            self.TextFieldTelePhone.text = @"020-87438288-958";	
        }
        
        //执法人员
        if (![parkingNode.name isEmpty] && parkingNode.name) {
            NSArray *nameArray = [parkingNode.name componentsSeparatedByString:@"、"];
            for (int i = 1; i<([nameArray count]+1); i++) {
                switch (i) {
                    case 1:
                        self.textEnforcerName1.text = [nameArray objectAtIndex:0];
                        self.textEnforcerNumber1.text = [UserInfo exelawIDForUserName:[nameArray objectAtIndex:0]];
                        break;
                    case 2:
                        self.textEnforcerName2.text = [nameArray objectAtIndex:1];
                        self.textEnforcerNumber2.text = [UserInfo exelawIDForUserName:[nameArray objectAtIndex:1]];
                        break;
                    case 3:
                        self.textEnforcerName3.text = [nameArray objectAtIndex:2];
                        self.textEnforcerNumber3.text = [UserInfo exelawIDForUserName:[nameArray objectAtIndex:2]];
                    default:
                        break;
                }
            }
        }else{
            NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
            NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
            self.textEnforcerName1.text = currentUserName;
            self.textEnforcerNumber1.text = [UserInfo exelawIDForUserName:currentUserName];
        }
        
        
        
        [[AppDelegate App] saveContext];
        
        
    }
}

-(void)pageSaveInfo
{
    ParkingNode *parkingNode = [ParkingNode parkingNodesForCase:self.caseID];
    if (parkingNode) {
        parkingNode.address = self.textParkingAddress.text;
        parkingNode.citizen_name = self.textCarNumber.text;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        parkingNode.date_start = [dateFormatter dateFromString:self.textDateStart.text];
        parkingNode.department = self.textFieldOfficeAddress.text;
        parkingNode.departmentaddress = self.TextFieldHandleAddress.text;
        parkingNode.dNo = self.textCitizenDNo.text;
        parkingNode.fNo = self.textLabelType.text;
        parkingNode.limitday = self.textFieldPeriodLimit.text;
        parkingNode.ownerorg = self.textCarOwnerOrgName.text;
        parkingNode.ownerorgaddress = self.textCarOwnerOrgAddress.text;
        parkingNode.relation = self.textRelation.text;
        parkingNode.telephone = self.TextFieldTelePhone.text;
        parkingNode.date_send = [NSDate date];
        parkingNode.date_end = parkingNode.date_send;
        
        if (![self.textEnforcerName1.text isEmpty]) {
            parkingNode.name = self.textEnforcerName1.text;
            if (![self.textEnforcerName2.text isEmpty]) {
                parkingNode.name = [parkingNode.name stringByAppendingFormat:@"、%@",self.textEnforcerName2.text];
                if (![self.textEnforcerName3.text isEmpty]) {
                    parkingNode.name = [parkingNode.name stringByAppendingFormat:@"、%@",self.textEnforcerName3.text];
                }
            }
        }
        
        if (![self.textFieldPlacePrefix.text isEmpty] && ![self.textFieldStationStart.text isEmpty]) {
            parkingNode.happenplace = [self.textFieldPlacePrefix.text stringByAppendingFormat:@"----%@",self.textFieldStationStart.text];
        }
        
        
        
        
        [[AppDelegate App] saveContext];
        
    }
    
    
    
    
}



- (BOOL)shouldGenereateDefaultDoc {
    return NO;
}

#pragma mark - CasePrintProtocol

- (NSString *)templateNameKey
{
   
    return DocNameKeyPei_ZeLingCheLiangTingShiTongZhiShu;
}

- (id)dataForPDFTemplate
{
    

    id happenDate = @{};
    NSString *automobileNumber = @"";
    NSString *placePrefix = @"";
    NSString *stationStart = @"";
    NSString *caseDescription = @"";
    NSString *parkingAddress = @"";
    NSString *periodLimit = @"";
    NSString *officeAddress = @"";
    NSString *carowner = @"";
    NSString *carownerAddress = @"";
    NSString *personName = @"";
    NSString *cardNo = @"";
    NSString *personAddress = @"";
    NSString *relationShip = @"";
    NSString *carNumber = @"";
    NSString *enforceAddress = @"";
    NSString *fNo = @"";
    id  stopTime = @{};
    NSString *department = @"";
    NSString *telephone = @"";
    
    NSString *carOwnerOrgName = @"";
    NSString *carOwnerOrgAddress = @"";
    
    NSString *enforcerName1 = @"";
    NSString *enforcerName2 = @"";
    NSString *enforcerName3 = @"";
    NSString *enforcerNumber1 = @"";
    NSString *enforcerNumber2 = @"";
    NSString *enforcerNumber3 = @"";

    
    carowner = NSStringNilIsBad(self.textCarOwnerName.text);
    carownerAddress = NSStringNilIsBad(self.textCarOwnerAddress.text);
    carOwnerOrgName = NSStringNilIsBad(self.textCarOwnerOrgName.text);
    carOwnerOrgAddress = NSStringNilIsBad(self.textCarOwnerOrgAddress.text);
    carowner = NSStringNilIsBad(self.textCarOwnerName.text);
    personName = NSStringNilIsBad(self.textCitizenName.text);
    personAddress = NSStringNilIsBad(self.textCitizenAddress.text);
    cardNo = NSStringNilIsBad(self.textCitizenDNo.text);
    relationShip = NSStringNilIsBad(self.textRelation.text);
    automobileNumber = NSStringNilIsBad(self.textCarNumber.text);
    enforcerName1 = NSStringNilIsBad(self.textEnforcerName1.text);
    enforcerName2 = NSStringNilIsBad(self.textEnforcerName2.text);
    enforcerName3 = NSStringNilIsBad(self.textEnforcerName3.text);
    enforcerNumber1 = NSStringNilIsBad(self.textEnforcerNumber1.text);
    enforcerNumber2 = NSStringNilIsBad(self.textEnforcerNumber2.text);
    enforcerNumber3 = NSStringNilIsBad(self.textEnforcerNumber3.text);
    
    
    id enforcer = @{
                    @"name1":enforcerName1,
                    @"name2":enforcerName2,
                    @"name3":enforcerName3,
                    @"num1":enforcerNumber1,
                    @"num2":enforcerNumber2,
                    @"num3":enforcerNumber3
                    };
    
    
    
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        //Citizen * citizen = [Citizen citizenForName:nil nexus:@"当事人" case:self.caseID];
        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy年MM月dd日mm分hh时mm分"];
//        [dateFormatter setLocale:[NSLocale currentLocale]];
//        NSString *dateString = [dateFormatter stringFromDate:caseInfo.happen_date];
//        NSArray *dateComponents = [dateString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"年月日时分"]];
//        if (dateComponents.count > 2) {
//            happenDate = @{
//                           @"year": dateComponents[0],
//                           @"month": dateComponents[1],
//                           @"day": dateComponents[2],
//                           @"hour":dateComponents[3],
//                           @"minute":dateComponents[4],
//                           };
//        }
        
//        RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
//        if (roadSegment) {
//            placePrefix = roadSegment.place_prefix1;
//        }
        if (![self.textFieldPlacePrefix.text isEmpty] && self.textFieldPlacePrefix.text) {
            placePrefix = self.textFieldPlacePrefix.text;
        }
        
        if (![self.textFieldStationStart.text isEmpty] && self.textFieldStationStart.text) {
            stationStart = self.textFieldStationStart.text;
        }
        
//        stationStart = [caseInfo fullCaseMarkAfterK:NO];
        
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if (caseProveInfo) {
            caseDescription = caseProveInfo.case_short_desc;
        }
        
        ParkingNode *parkingNode = [ParkingNode parkingNodesForCase:self.caseID];
        if (parkingNode) {
           
                if ([parkingNode.citizen_name isEqualToString:self.textFieldAutomobileNumber.text]) {
                    parkingAddress = NSStringNilIsBad(parkingNode.address);
                    carNumber = NSStringNilIsBad(parkingNode.citizen_name);
                    enforceAddress = NSStringNilIsBad(parkingNode.departmentaddress);
                    fNo = NSStringNilIsBad(parkingNode.fNo);
                    department = NSStringNilIsBad(parkingNode.department);
                    telephone = NSStringNilIsBad(parkingNode.telephone);
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
                    [dateFormatter setLocale:[NSLocale currentLocale]];
                    NSString *dateString = [dateFormatter stringFromDate:parkingNode.date_start];
                    NSArray *dateComponents = [dateString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"年月日时分"]];
                    if (dateComponents.count > 4) {
                        stopTime = @{
                                       @"year": dateComponents[0],
                                       @"month": dateComponents[1],
                                       @"day": dateComponents[2],
                                       @"hour":dateComponents[3],
                                       @"minute":dateComponents[4],
                                       };
                    }

                }
            
        }
        
        NSArray *typeValues = [Systype typeValueForCodeName:@"停驶期限"];
        if (typeValues.count > 0) {
            NSString *typeValue = typeValues[0];
            periodLimit = typeValue;
        } else {
            periodLimit = @"七";
        }
        
        OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
        if (orgInfo) {
            officeAddress = orgInfo.orgshortname;
        }
    }
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *timeStr = self.textPrintDate.text;
    NSArray *timeArray = [timeStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"年月日"]];
    id printTime = @{
                     @"year": [timeArray objectAtIndex:0],
                     @"month":[timeArray objectAtIndex:1],
                     @"day":[timeArray objectAtIndex:2]
                     };
    
    
    return @{
             @"carowner": carowner,
             @"carownerAddress": carownerAddress,
             @"personName": personName,
             @"cardNo": cardNo,
             @"personAddress": personAddress,
             @"relationShip": relationShip,

             @"happenDate": happenDate,
             @"automobileNumber": automobileNumber,
             @"placePrefix": placePrefix,
             @"stationStart": stationStart,
             @"caseDescription": caseDescription,
             @"parkingAddress": parkingAddress,
             @"periodLimit": periodLimit,
             @"officeAddress": officeAddress,
             @"carNumber" : carNumber,
             @"enforceAddress" :enforceAddress,
             @"fNo" : fNo,
             @"stopTime": stopTime,
             @"department": department,
             @"telephone": telephone,
             
             @"carOwnerOrgName":carOwnerOrgName,
             @"carOwnerOrgAddress":carOwnerOrgAddress,
             
             @"enforcer":enforcer,
             @"printTime":printTime
             };
}

#pragma mark - ListSelectPopoverDelegate

- (void)setSelectData:(NSString *)data {
    for (UITextField *textField in self.view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            if (self.popoverIndex == textField.tag) {
                [textField setText:data];
                [textField resignFirstResponder];
            }
        }
    }
    [self.popover dismissPopoverAnimated:YES];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == kTextFieldTagAutoMobileNumber) {
        
    }
}


#pragma mark - IBAction
/*
- (IBAction)textFieldAutomobileNumber_touched:(UITextField *)sender {
    
    ListSelectViewController *listSelectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelectPopover"];
    listSelectViewController.delegate = self;
    ParkingNode *parkingNode = [ParkingNode parkingNodesForCase:self.caseID];
    listSelectViewController.data = [parkingNode valueForKeyPath:@"@unionOfObjects.citizen_name"];
    
    if ([self.popover isPopoverVisible] && (self.popoverIndex != sender.tag)) {
        [self.popover dismissPopoverAnimated:YES];
        return;
    }
    
    if (self.popover == nil) {
        self.popover = [[UIPopoverController alloc] initWithContentViewController:listSelectViewController];
    } else {
        [self.popover setContentViewController:listSelectViewController];
    }
    self.popoverIndex = sender.tag;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [self.popover setPopoverContentSize:CGSizeMake(CGRectGetWidth(listSelectViewController.view.bounds), 100) animated:YES];

}
*/

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
    NSString * str = self.textEnforcerName1.text;
    if (self.textFieldTag == 200) {
        self.textEnforcerName1.text = name;
        self.textEnforcerNumber1.text = [UserInfo exelawIDForUserName:name];
    }else if (self.textFieldTag == 201){
        self.textEnforcerName2.text = name;
        self.textEnforcerNumber2.text = [UserInfo exelawIDForUserName:name];
    }else if (self.textFieldTag == 202){
        self.textEnforcerName3.text = name;
        self.textEnforcerNumber3.text = [UserInfo exelawIDForUserName:name];
    }
    if (self.textFieldTag == 200 && [name isEqualToString:str]) {
        self.textEnforcerName1.text = @"";
        self.textEnforcerNumber1.text = @"";
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 200:
        case 201:
        case 202:
            return NO;
            break;
        default:
            return YES;
            break;
    }
}
//多车辆中的选择车辆
- (IBAction)showAutoNumerPicker:(id)sender{
    if (([_autoNumberPicker isPopoverVisible])) {
        [_autoNumberPicker dismissPopoverAnimated:YES];
    } else {
        AutoNumerPickerViewController *pickerVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AutoNumberPicker"];
        pickerVC.delegate=self;
        pickerVC.caseID=self.caseID;
        pickerVC.pickerType=kParkingNodeAutoNumber;
        _autoNumberPicker=[[UIPopoverController alloc] initWithContentViewController:pickerVC];
        [_autoNumberPicker presentPopoverFromRect:[(UITextField*)sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
}
-(void)setAutoNumberText:(NSString *)aAutoNumber{
    [_autoNumberPicker dismissPopoverAnimated:YES];
    [self pageLoadInfo:aAutoNumber];
}

@end
