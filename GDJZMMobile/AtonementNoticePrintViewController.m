//
//  AtonementNoticePrintViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-29.
//
//

#import "AtonementNoticePrintViewController.h"
#import "AtonementNotice.h"
#import "CaseDeformation.h"
#import "CaseProveInfo.h"
#import "Citizen.h"
#import "CaseInfo.h"
#import "RoadSegment.h"
#import "OrgInfo.h"
#import "UserInfo.h"
#import "NSNumber+NumberConvert.h"
#import "Systype.h"
#import "MatchLaw.h"
#import "MatchLawDetails.h"
#import "LawItems.h"
#import "LawbreakingAction.h"
#import "Laws.h"

#import "ListSelectViewController.h"

@interface AtonementNoticePrintViewController ()
@property (nonatomic,retain) UIPopoverController *autoNumberPicker;
@property (nonatomic,retain) AtonementNotice *notice;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) CaseInfo *caseInfo;
@property (nonatomic, retain) Citizen *citizen;
@property (nonatomic, retain) CaseProveInfo *proveInfo;

@property (nonatomic,retain) UIPopoverController * pickerPopover;
- (void)generateDefaultsForNotice:(AtonementNotice *)notice;
@end

@implementation AtonementNoticePrintViewController
@synthesize labelCaseCode = _labelCaseCode;

@synthesize textBankName = _textBankName;
@synthesize caseID = _caseID;
@synthesize notice = _notice;
@synthesize data = _data;

@synthesize autoNumberPicker=_autoNumberPicker;

- (void)viewDidLoad
{
    [super setCaseID:self.caseID];
    self.textAutomobileNumber.delegate = self;
    [self LoadPaperSettings:@"AtonementNoticeTable"];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 690);
    if (![self.caseID isEmpty]) {
         [self setAutoNumberText:nil];
     }
    [super viewDidLoad];
    
    self.textlian.delegate = self;
}

- (void)viewDidUnload
{
    [self setLabelCaseCode:nil];

    [self setNotice:nil];
	[self setTextBankName:nil];
    [self setTextRoadSegment:nil];
    [self setTextSide:nil];
    [self setTextPlace:nil];
    [self setTextStationKM:nil];
    [self setTextStationM:nil];
    [self setTextYear:nil];
    [self setTextMonth:nil];
    [self setTextDay:nil];
    [self setTextAutomobileNumber:nil];
    [super viewDidUnload];
}

//我写的保存
- (void)pageSaveInfo{
    [self savePageInfo];
    self.caseInfo = [CaseInfo caseInfoForID:self.caseID];
    self.caseInfo.side = self.textSide.text;
    self.caseInfo.place = self.textPlace.text;
    [[AppDelegate App] saveContext];
}
- (void)savePageInfo{
    self.notice.pay_mode = self.textPay_mode.text;
    self.citizen.address = self.textadress.text;
    [[AppDelegate App] saveContext];
}

- (void)generateDefaultAndLoad{
    NSString *aAutoNumber = nil;
    NSArray *array = [Citizen allCitizenNameForCase:self.caseID];
    for (Citizen *c in array) {
        aAutoNumber = c.automobile_number;
        self.citizen = c;
        if(aAutoNumber) break;
    }

    [self generateDefaultsForNotice:self.notice withAuotNumber:nil];
    [self loadNoticeToPage];
}


/*test by lxm 无效*/
//打印预览
-(NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self savePageInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        NSString * empty_xml;
        if([self.textlian.text isEqualToString:@"第一联：路政存"]){
            empty_xml = @"AtonementNoticeTable";;
        }
        if([self.textlian.text isEqualToString:@"第二联：当事人存"]){
            empty_xml = @"AtonementNoticeTable1";;
        }
        if([self.textlian.text isEqualToString:@"第三联：交给交警部门"]){
            empty_xml = @"AtonementNoticeTable2";;
        }
//        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.notice];
        //add by lxm 2013.05.08
        self.labelCaseCode.text = [[NSString alloc] initWithFormat:@"(%@)年%@交赔字第0%@号",self.caseInfo.case_mark2, [[AppDelegate App].projectDictionary objectForKey:@"cityname"], self.caseInfo.full_case_mark3];
        [self drawStaticTable:empty_xml];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.citizen];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.caseInfo];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.notice];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.proveInfo];
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}
//套打      确定套打位置
- (NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    [self savePageInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        [self drawStaticTable:@"AtonementNoticeTable"];
        //        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.notice];
        //add by lxm 2013.05.08
        self.labelCaseCode.text = [[NSString alloc] initWithFormat:@"(%@)年%@交赔字第0%@号",self.caseInfo.case_mark2, [[AppDelegate App].projectDictionary objectForKey:@"cityname"], self.caseInfo.full_case_mark3];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.citizen];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.caseInfo];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.notice];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.proveInfo];
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}








//
//-(NSURL *)toFullPDFWithTable:(NSString *)filePath{
//    [self savePageInfo];
//    if (![filePath isEmpty]) {
//        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
//        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
//        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        [self drawStaticTable:@"AtonementNoticeTable"];
//        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.notice];
//
//        //add by lxm 2013.05.08
//        self.labelCaseCode.text = [[NSString alloc] initWithFormat:@"(%@)年%@交赔字第0%@号",self.caseInfo.case_mark2, [[AppDelegate App].projectDictionary objectForKey:@"cityname"], self.caseInfo.full_case_mark3];
//        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.citizen];
//
//        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.proveInfo];
//
//
//        UIGraphicsEndPDFContext();
//        return [NSURL fileURLWithPath:filePath];
//    } else {
//        return nil;
//    }
//}

//-(NSURL *)toFullPDFWithPath_deprecated:(NSString *)filePath{
//    [self savePageInfo];
//    if (![filePath isEmpty]) {
//        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
//        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
//        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        //根据配置绘制固定的表格
//        //[self drawStaticTable1:@"AtonementNoticeTable"];
//        [self drawStaticTable:@"AtonementNoticeTable"];
//        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.notice];
//
//        //add by lxm 2013.05.08
//
//        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.caseInfo];
//
//
//        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.citizen];
//
//
//        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.proveInfo];
//
//        UIGraphicsEndPDFContext();
//        return [NSURL fileURLWithPath:filePath];
//    } else {
//        return nil;
//    }
//}
//
//-(NSURL *)toFormedPDFWithPath_deprecated:(NSString *)filePath{
//    [self savePageInfo];
//    if (![filePath isEmpty]) {
//        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
//        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
//        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
//        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.notice];
//
//
//        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.caseInfo];
//
//        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.citizen];
//
//        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.proveInfo];
//
//        UIGraphicsEndPDFContext();
//        return [NSURL fileURLWithPath:formatFilePath];
//    } else {
//        return nil;
//    }
//}

#pragma CasePrintProtocol
- (NSString *)templateNameKey
{
    return DocNameKeyPei_PeiBuChangTongZhiShu;
}


-(id)dataForPDFTemplate
{
    NSString *roadSegment = @"";
    NSString *side = @"";
    NSString *place = @"";
    NSString *stationKM = @"";
    NSString *stationM = @"";
    NSString *year = @"";
    NSString *month = @"";
    NSString *day = @"";
    NSString *automobileNumber = @"";
    NSString *payDetail = @"";
    NSString *payLocation = @"";
    NSString *payProcessingTime = @"";
    NSString *payTelNumber = @"";
    
    roadSegment = self.textRoadSegment.text;
    side = self.textSide.text;
    place = self.textPlace.text;
    stationKM = self.textStationKM.text;
    stationM = self.textStationM.text;
    year = self.textYear.text;
    month = self.textMonth.text;
    day = self.textDay.text;
    automobileNumber = self.textAutomobileNumber.text;

    payLocation = self.textBankName.text;

    
    id data = @{
                @"roadSegment": roadSegment,
                @"side":side,
                @"place":place,
                @"stationKM":stationKM,
                @"stationM":stationM,
                @"year":year,
                @"month":month,
                @"day":day,
                @"automobileNumber":automobileNumber,
                @"payDetail":payDetail,
                @"payLocation":payLocation,
                @"payProcessingTime":payProcessingTime,
                @"payTelNumber":payTelNumber
                };
    
    return data;
}

-(void)loadNoticeToPage{
    self.textBankName.text = [[Systype typeValueForCodeName:@"交款地点"] objectAtIndex:0];
    self.caseInfo = [CaseInfo caseInfoForID:self.caseID];
    //副标题
    self.labelCaseCode.text = [[NSString alloc] initWithFormat:@"(%@)年%@交赔字第 %@ 号",self.caseInfo.case_mark2, [[AppDelegate App].projectDictionary objectForKey:@"cityname"], self.caseInfo.full_case_mark3];
    self.textadress.text = self.citizen.address;
    self.textcasereason.text = self.caseInfo.case_reason;
    self.anyoutext.text = [self.notice case_long_desc_small];
    NSArray * deformations = [CaseDeformation deformationsForCase:self.caseID];
    double summary=[[deformations valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    NSNumber *sumNum      = @(summary);
    NSString *numString   = [sumNum numberConvertToChineseCapitalNumberString];
    self.notice.pay_mode = numString;
    self.textPay_mode.text = numString;
    self.citizenparty.text = self.citizen.party;
    
    
    self.textStationKM.text=[NSString stringWithFormat:@"%d", self.caseInfo.station_start.integerValue/1000];
    self.textStationM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_start.integerValue%1000];
    
    self.textRoadSegment.text=[RoadSegment roadNameFromSegment:self.caseInfo.roadsegment_id];
    self.textSide.text = self.caseInfo.side;
    self.textPlace.text = self.caseInfo.place;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:self.caseInfo.happen_date];
    NSArray * tempArr = [[NSArray alloc]initWithArray:[[strDate substringToIndex:10] componentsSeparatedByString:@"-"]];
    NSString *year = [tempArr objectAtIndex:0];
    NSString *month = [tempArr objectAtIndex:1];
    NSString *day = [tempArr objectAtIndex:2];
    self.textYear.text = year;
    self.textMonth.text = month;
    self.textDay.text = day;
    
    
    //损失的路产
    self.data = [[CaseDeformation deformationsForCase:self.caseID forCitizen:self.citizen.automobile_number] mutableCopy];
    NSString *payDeformations = @"    根据《中华人民共和国公路法》第七条、八十五条、《广东省高速公路管理条例》第二十五条，事故车辆损坏路产需按价赔偿：\n";
    int number = 1;
    for (CaseDeformation *deformation in self.data) {
        payDeformations = [payDeformations stringByAppendingFormat:@"%d、",number];
        number++;
        payDeformations = [[payDeformations stringByAppendingString:deformation.roadasset_name] stringByAppendingFormat:@":%@%@\n",deformation.quantity,deformation.unit];
    }
    
    self.textAutomobileNumber.text = self.notice.citizen_name;

    
}

- (void)generateDefaultsForNotice:(AtonementNotice *)notice withAuotNumber:(NSString *)aAutoNumber{
    [self setCitizenAndProveInfo];
    
    if ([self.proveInfo.event_desc isEmpty] || self.proveInfo.event_desc == nil) {
        self.proveInfo.event_desc = [CaseProveInfo generateEventDescForCase:self.caseID];
    }
    NSDateFormatter *codeFormatter = [[NSDateFormatter alloc] init];
    [codeFormatter setDateFormat:@"yyyyMM'0'dd"];
    [codeFormatter setLocale:[NSLocale currentLocale]];
    notice.code = [codeFormatter stringFromDate:[NSDate date]];
    NSRange range = [self.proveInfo.event_desc rangeOfString:@"于"];
    if (range.location != NSNotFound) {
        notice.case_desc = [self.proveInfo.event_desc substringFromIndex:range.location+1];
    }
    
    notice.witness = @"勘验检查笔录、询问笔录";
    notice.check_organization = @"广东省公路管理局";
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    notice.organization_id = [[OrgInfo orgInfoForOrgID:[UserInfo userInfoForUserID:currentUserID].organization_id] valueForKey:@"orgname"];
    
    
    notice.citizen_name = aAutoNumber;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MatchLaw" ofType:@"plist"];
    NSDictionary *matchLaws = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *payReason = @"";
    if (matchLaws) {
        NSString *breakStr = @"";
        NSString *matchStr = @"";
        NSString *payStr = @"";
        NSDictionary *matchInfo = [[matchLaws objectForKey:@"case_desc_match_law"] objectForKey:self.proveInfo.case_desc_id];
        if (matchInfo) {
            if ([matchInfo objectForKey:@"breakLaw"]) {
                breakStr = [(NSArray *)[matchInfo objectForKey:@"breakLaw"] componentsJoinedByString:@"、"];
            }
            if ([matchInfo objectForKey:@"matchLaw"]) {
                matchStr = [(NSArray *)[matchInfo objectForKey:@"matchLaw"] componentsJoinedByString:@"、"];
            }
            if ([matchInfo objectForKey:@"payLaw"]) {
                payStr = [(NSArray *)[matchInfo objectForKey:@"payLaw"] componentsJoinedByString:@"、"];
            }
        }
        
        payReason = [NSString stringWithFormat:@"%@%@的违法事实清楚，其行为违反了%@之规定，根据%@、并依照%@的规定，当事人应当承担民事责任，赔偿路产损失。", self.citizen.party, self.proveInfo.case_short_desc, breakStr, matchStr, payStr];
        
    }
    notice.pay_reason = payReason;
    notice.date_send = [NSDate date];
    [[AppDelegate App] saveContext];
}

-(NSArray *) subString:(NSString *)str {
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    if (str != nil){
        
        //从开始截取到指定索引字符   但不包含此字符  。
        NSString * tempStr1 = [str substringToIndex:str.length/2+1];
        
        //从指定字符串截取到末尾
        NSString * tempStr2 = [str substringFromIndex:str.length/2+1];
    
        [array addObject:tempStr1];
        
        [array addObject:tempStr2];
    }
    
    return array;
}

//多车辆中的选择车辆
- (IBAction)showAutoNumerPicker:(id)sender{
    if (([_autoNumberPicker isPopoverVisible])) {
        [_autoNumberPicker dismissPopoverAnimated:YES];
    } else {
        AutoNumerPickerViewController *pickerVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AutoNumberPicker"];
        pickerVC.delegate=self;
        pickerVC.caseID=_caseID;
        pickerVC.pickerType=kAutoNumber;
        _autoNumberPicker=[[UIPopoverController alloc] initWithContentViewController:pickerVC];
        [_autoNumberPicker presentPopoverFromRect:[(UITextField*)sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
}
-(void)setAutoNumberText:(NSString *)aAutoNumber{
    [_autoNumberPicker dismissPopoverAnimated:YES];
    self.citizen = nil;
    self.proveInfo =nil;
    self.caseInfo = nil;
    if (aAutoNumber == nil || [aAutoNumber isEmpty]) {
        NSArray *array = [Citizen allCitizenNameForCase:self.caseID];
        for (Citizen *c in array) {
            aAutoNumber = c.automobile_number;
            self.citizen = c;
            if(aAutoNumber) break;
        }
    }
    if(aAutoNumber == nil || [aAutoNumber isEmpty]) return;
    NSArray *noticeArray = [AtonementNotice AtonementNoticesForCase:self.caseID withCitizenName:aAutoNumber];
    if (noticeArray.count>0) {
        self.notice = [noticeArray objectAtIndex:0];
        [self setCitizenAndProveInfo];
        
    } else {
        self.notice = [AtonementNotice newDataObjectWithEntityName:@"AtonementNotice"];
        self.notice.caseinfo_id = self.caseID;
        self.notice.citizen_name = aAutoNumber;
        [self generateDefaultsForNotice:self.notice withAuotNumber:aAutoNumber];
        [[AppDelegate App] saveContext];
    }
    [self loadNoticeToPage];
}
-(void)setCitizenAndProveInfo{
    Citizen *citizen1=[Citizen citizenByAutomobileNumber:self.notice.citizen_name withNexus:@"当事人" withCase:self.caseID];
    
    
    self.proveInfo = nil;
    if (citizen1) {
        self.proveInfo = [CaseProveInfo proveInfoForCase:self.caseID withCitizenName:citizen1.party];
        self.citizen = citizen1;
    }
    if(!self.proveInfo){
        Citizen *citizen2=[Citizen citizenByAutomobileNumber:self.notice.citizen_name withNexus:@"当事人代表" withCase:self.caseID];
        if(citizen2){
            self.proveInfo = [CaseProveInfo proveInfoForCase:self.caseID withOrganizer:citizen2.party];
            self.citizen = citizen2;
        }
        if(!self.proveInfo){
            Citizen *citizen3=[Citizen citizenByAutomobileNumber:self.notice.citizen_name withNexus:@"被邀请人" withCase:self.caseID];
            self.proveInfo = [CaseProveInfo proveInfoForCase:self.caseID withInvitee:citizen3.party];
            self.citizen = citizen3;
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.textlian == textField) {
        [self touchdownlian:textField];
        return NO;
    }
    if (self.textAutomobileNumber == textField) {
        return NO;
    }
    return YES;
}


- (IBAction)touchdownlian:(id)sender {
    UITextField * field = (UITextField *)sender;
    ListSelectViewController *listPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"ListSelectPopover"];
    listPicker.delegate=self;
    listPicker.data = @[@"第一联：路政存",@"第二联：当事人存",@"第三联：交给交警部门"];
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:listPicker];
    CGRect rect = field.frame;
    [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    listPicker.pickerPopover=self.pickerPopover;
}

- (void)setSelectData:(NSString *)data{
    self.textlian.text = data;
}
@end
