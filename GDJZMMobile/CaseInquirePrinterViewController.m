//
//  CaseInquirePrinterViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-9.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "CaseInquirePrinterViewController.h"
#import "CasePrintViewController.h"
#import "UserInfo.h"
#import "Citizen.h"
#import "CaseInfo.h"
#import "TBXML+TBXML_TraverseAddition.h"
#import "TBXML.h"
#import "InquireInfoViewController.h"
#import "CaseProveInfo.h"
#import "RoadSegment.h"

#import "OrgInfo.h"



static NSString * const xmlName = @"InquireTable";
static NSString * const secondPageXmlName = @"InquireTable2_new"; //该文件改用来作为第二页 |  | 2013.7.30

enum kPageInfo {
    kPageInfoFirstPage = 0,
    kPageInfoSucessivePage
};

@interface CaseInquirePrinterViewController ()
@property (nonatomic, retain) CaseInquire *caseInquire;
@property (nonatomic, retain) UIPopoverController *pickerPopover;
@property (nonatomic, retain) CaseProveInfo *caseProveInfo;
//@property (nonatomic, retain) CaseInfo *caseInfo;
@property (nonatomic, retain) NSString *relation;
@property (nonatomic, retain) NSString *party;
@property (nonatomic,assign)int currentTextView;
@property (nonatomic,retain) UIPopoverController *citizenNamePicker;
@end

@implementation CaseInquirePrinterViewController
@synthesize caseInquire = _caseInquire;
@synthesize caseID=_caseID;
@synthesize textFieldTag = _textFieldTag;
@synthesize relation = _relation;
@synthesize party = _party;
- (void)viewDidLoad
{
    if (self.caseID && ![self.caseID isEmpty]) {
        [super setCaseID:self.caseID];
    
        
        self.caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if(self.caseProveInfo){
            if (self.caseProveInfo.citizen_name) {
                _relation = @"当事人";
                _party = self.caseProveInfo.citizen_name;
            }else if (self.caseProveInfo.invitee) {
                _relation = @"被邀请人";
                _party = self.caseProveInfo.invitee;
            }else if (self.caseProveInfo.organizer) {
                _relation = @"当事人代表";
                _party = self.caseProveInfo.organizer;
            }
        }
        

        
        
        //生成caseInquire
        [self testAndBuildInquireInfo];
        //从caseInquire中取出数据（若存在），填入页面
        [self getInquireInfoFillInTheBlank];
        
        [self LoadPaperSettings:xmlName];
        CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
        self.view.frame = viewFrame;
        
    }
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setTextQuestion2:nil];
    [self setTextQuestion3:nil];
    [self setTextQuestion4:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


-(void)testAndBuildInquireInfo
{
    
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseInquire" inManagedObjectContext:context];
    //通过caseinfo_id和answerer_name查询是否存在此caseInquire
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(proveinfo_id==%@) && (answerer_name==%@) && (relation==%@)",self.caseID,_party,_relation];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *tempArray=[context executeFetchRequest:fetchRequest error:nil];
    //存在则取出
    if (tempArray.count>0) {
        self.caseInquire=[tempArray objectAtIndex:0];
    } else {
        //不存在则新生成，并赋值
        self.caseInquire=[CaseInquire newDataObjectWithEntityName:@"CaseInquire"];
        self.caseInquire.proveinfo_id=self.caseID;
        self.caseInquire.answerer_name=_party;
        self.caseInquire.relation = _relation;
        
        
    }
    Citizen *citizen = [Citizen citizenForCitizenName:_party nexus:_relation case:self.caseID];
    self.caseInquire.address = citizen.address;
    [[AppDelegate App] saveContext];
    
}




///pageload
//从caseInquire中取出数据（若存在），填入页面
-(void)getInquireInfoFillInTheBlank
{
    
    for (UIView *view in self.view.subviews) {
        if([view isKindOfClass:[UITextField class]]){
            ((UITextField*)view).text = @"";
        }else if([view isKindOfClass:[UITextView class]]){
            ((UITextView*)view).text = @"";
        }
    }
    //询问时间
    if (!self.caseInquire.date_inquired && self.caseProveInfo.start_date_time) {
        self.caseInquire.date_inquired = self.caseProveInfo.start_date_time;
    }else if(!self.caseInquire.date_inquired){
        self.caseInquire.date_inquired = [NSDate date];
    }
    if (self.caseInquire.date_inquired) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        self.textdate_inquired.text = [dateFormatter stringFromDate:self.caseInquire.date_inquired];
    }
    
    //询问地点
    if (!self.caseInquire.locality || [self.caseInquire.locality isEmpty]) {
        self.caseInquire.locality = [self getLocality];
    }
    self.textlocality.text = self.caseInquire.locality;
    
    //询问人
    if ([self.caseInquire.inquirer_name isEmpty] || !self.caseInquire.inquirer_name) {
        NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
        NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
        self.textinquirer_name.text = currentUserName;
    }else
        self.textinquirer_name.text = self.caseInquire.inquirer_name;
    
    //记录人
    if ([self.caseInquire.recorder_name isEmpty] || !self.caseInquire.recorder_name) {
        NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
        NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
        self.textrecorder_name.text = currentUserName;
    }else
        self.textrecorder_name.text = self.caseInquire.recorder_name;
    
    //被询问人
    if (![self.caseInquire.answerer_name isEmpty] && self.caseInquire.answerer_name) {
        self.textanswerer_name.text = self.caseInquire.answerer_name;
    }
    //  self.inquireNotequestionone.text;NSString * question1 = @"问：我们是广东省公路事务中心北二环高速公路路政大队的路政员，现就损坏路产一案作一下询问，请如实提供情况。";
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString * currentOrgname = [[OrgInfo orgInfoForOrgID:[UserInfo userInfoForUserID:currentUserID].organization_id] valueForKey:@"orgname"];
    self.inquireNotequestionone.text = [NSString stringWithFormat:@"问：我们是%@的路政员，现就损坏路产一案作一下询问，请如实提供情况。",currentOrgname];
    //inquireNote1234
    if (![self.caseInquire.inquiry_note isEmpty] && self.caseInquire.inquiry_note) {
        NSArray *dateComponents = [self.caseInquire.inquiry_note componentsSeparatedByString:@"-!-"];
        if (dateComponents.count >= 4) {
            self.textQuestion1.text = [dateComponents objectAtIndex:0];
            self.textQuestion2.text = [dateComponents objectAtIndex:1];
            self.textQuestion3.text = [dateComponents objectAtIndex:2];
            self.textQuestion4.text = [dateComponents objectAtIndex:3];
        }
    }
    
    
    if(![self.caseInquire.answer1 isEmpty] && self.caseInquire.answer1){
        self.textQuestion1.text = self.caseInquire.answer1;
    }
    if(![self.caseInquire.answer2 isEmpty] && self.caseInquire.answer2){
        self.textQuestion2.text = self.caseInquire.answer2;
    }

    if(![self.caseInquire.answer3 isEmpty] && self.caseInquire.answer3){
        self.textQuestion3.text = self.caseInquire.answer3;
    }

    if(![self.caseInquire.answer4 isEmpty] && self.caseInquire.answer4){
        self.textQuestion4.text = self.caseInquire.answer4;
    }

    
    
    Citizen *citizen = [Citizen citizenByCitizenName:self.caseInquire.answerer_name nexus:_relation case:self.caseID];
    if (citizen) {
        //身份证号
        if (![citizen.card_no isEmpty] && citizen.card_no) {
            self.textsex.text = citizen.card_no;
        }
        
        //与案件关系
        if (![citizen.nexus isEmpty] && citizen.nexus) {
            self.textrelation.text = citizen.nexus;
        }
        
        //工作单位和职务
        if ([self.caseInquire.company_duty isEmpty] || !self.caseInquire.company_duty) {
            if (citizen.org_name && citizen.org_principal_duty) {
                self.caseInquire.company_duty = [NSString stringWithFormat:@"%@%@", citizen.org_name, citizen.org_principal_duty];
            }
        }self.textcompany_duty.text = self.caseInquire.company_duty;
        
        //电话
        if ([self.caseInquire.phone isEmpty] || !self.caseInquire.phone) {
            if (citizen.tel_number && ![citizen.tel_number isEmpty]) {
                self.caseInquire.phone = citizen.tel_number;
            }
        }self.textphone.text = self.caseInquire.phone;
        
        //详细地址
        if ([self.caseInquire.address isEmpty] || !self.caseInquire.address) {
            if (![citizen.address isEmpty] && citizen.address) {
                self.caseInquire.address = citizen.address;
            }
        }self.textaddress.text = self.caseInquire.address;
        
        //邮编
        if ([self.caseInquire.postalcode isEmpty] || !self.caseInquire.postalcode) {
            if (![citizen.postalcode isEmpty] && citizen.postalcode) {
                self.caseInquire.postalcode = citizen.postalcode;
            }
        }self.textpostalcode.text = self.caseInquire.postalcode;
        
    }
    
    [[AppDelegate App] saveContext];
    
}

-(NSString *)getLocality
{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
    [numFormatter setPositiveFormat:@"000"];
    NSInteger stationStartM=caseInfo.station_start.integerValue%1000;
    NSString *stationStartKMString=[NSString stringWithFormat:@"%d", caseInfo.station_start.integerValue/1000];
    NSString *stationStartMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
    NSString *stationString;
    if (caseInfo.station_end.integerValue == 0 || caseInfo.station_end.integerValue == caseInfo.station_start.integerValue  ) {
        stationString=[NSString stringWithFormat:@"K%@+%@m处",stationStartKMString,stationStartMString];
    } else {
        NSInteger stationEndM=caseInfo.station_end.integerValue%1000;
        NSString *stationEndKMString=[NSString stringWithFormat:@"%d",caseInfo.station_end.integerValue/1000];
        NSString *stationEndMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationEndM]];
        stationString=[NSString stringWithFormat:@"K%@+%@至K%@+%@m处",stationStartKMString,stationStartMString,stationEndKMString,stationEndMString ];
    }
    NSString *roadName=[RoadSegment roadNameFromSegment:caseInfo.roadsegment_id];
    NSString * localityString=[NSString stringWithFormat:@"%@%@%@",roadName,caseInfo.side,stationString];
    return localityString;
}



-(void)pageSaveInfo{
    Citizen *citizen = [Citizen citizenForCitizenName:self.caseInquire.answerer_name nexus:self.caseInquire.relation case:self.caseID];
    citizen.tel_number = NSStringNilIsBad(self.textphone.text);
    citizen.age = [NSNumber numberWithInt: [self.textage.text integerValue]];
    citizen.address = NSStringNilIsBad(self.textaddress.text);
    citizen.card_no = NSStringNilIsBad(self.textsex.text);
    citizen.nexus = NSStringNilIsBad(self.textrelation.text);
    self.caseInquire.locality = NSStringNilIsBad(self.textlocality.text);
    self.caseInquire.phone = NSStringNilIsBad(self.textphone.text);
    self.caseInquire.address = NSStringNilIsBad(self.textaddress.text);
    
    citizen.postalcode = NSStringNilIsBad(self.textpostalcode.text);
    self.caseInquire.postalcode = NSStringNilIsBad(self.textpostalcode.text);
    
    self.caseInquire.company_duty = NSStringNilIsBad(self.textcompany_duty.text);
    self.caseInquire.inquirer_name = NSStringNilIsBad(self.textinquirer_name.text);
    self.caseInquire.recorder_name = NSStringNilIsBad(self.textrecorder_name.text);
    self.caseInquire.relation = NSStringNilIsBad(self.textrelation.text);
    
//    NSString * question1 = @"问：我们是广东省公路事务中心北二环高速公路路政大队的路政员，现就损坏路产一案作一下询问，请如实提供情况。";
    NSString * question1 = self.inquireNotequestionone.text;
    
    NSString * question2 = @"问：什么原因导致事故的发生造成路产的损失？";
    
    NSString * question3 = @"问：有没人员伤亡？";
    
    NSString * question4 = @"问：现根据《中华人民共和国公路法》第七条、《广东省公路条例》第十七条、《广东省高速公路管理条例》第二十五条的有关条款规定对你损坏路产的行为依法作出索赔，请问还有无其他补充？";
    
    self.caseInquire.inquiry_note = NSStringNilIsBad([NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",question1,self.textQuestion1.text,question2,self.textQuestion2.text,question3,self.textQuestion3.text,question4,self.textQuestion4.text]);
    
    self.caseInquire.answer1 = NSStringNilIsBad(self.textQuestion1.text);
    
    self.caseInquire.answer2 = NSStringNilIsBad(self.textQuestion2.text);
    
    self.caseInquire.answer3 = NSStringNilIsBad(self.textQuestion3.text);
    
    self.caseInquire.answer4 = NSStringNilIsBad(self.textQuestion4.text);
    
    if (![self.textdate_inquired.text isEmpty]) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        self.caseInquire.date_inquired = [dateFormatter dateFromString:self.textdate_inquired.text];
    }

    [[AppDelegate App] saveContext];
}


- (void)pageLoadInfo{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    self.textdate_inquired.text =[dateFormatter stringFromDate:self.caseInquire.date_inquired];
    self.textlocality.text = self.caseInquire.locality;
//    self.textinquirer_name.text = self.caseInquire.inquirer_name;
//    self.textinquirer_name.text = self.caseProveInfo.citizen_name;
    if ([self.caseInquire.inquirer_name isEmpty] || !self.caseInquire.inquirer_name) {
        NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
        NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
        self.textinquirer_name.text = currentUserName;
    }else
        self.textinquirer_name.text = self.caseInquire.inquirer_name;
    
    
    
    self.textrecorder_name.text = self.caseInquire.recorder_name;
    self.textanswerer_name.text = self.caseInquire.answerer_name;
    
    self.textage.text = (self.caseInquire.age.integerValue==0)?@"":[NSString stringWithFormat:@"%d",self.caseInquire.age.integerValue];
    self.textrelation.text = self.caseInquire.relation;
    
    Citizen *citizen = [Citizen citizenByCitizenName:self.caseInquire.answerer_name nexus:self.caseInquire.relation case:self.caseID];
    
    self.textsex.text = citizen.card_no;
    
    if ([self.caseInquire.company_duty isEmpty]) {
        self.caseInquire.company_duty = [NSString stringWithFormat:@"%@%@", citizen.org_name, citizen.org_principal_duty];
    }
    self.textcompany_duty.text = self.caseInquire.company_duty;
    
    if ([self.caseInquire.phone isEmpty]) {
        self.caseInquire.phone = citizen.tel_number;
    }
    self.textphone.text = self.caseInquire.phone;
    if ([self.caseInquire.address isEmpty]) {
        self.caseInquire.address = citizen.address;
    }
    self.textaddress.text = self.caseInquire.address;
    if ([self.caseInquire.postalcode isEmpty]) {
        self.caseInquire.postalcode = citizen.postalcode;
    }
    self.textpostalcode.text = self.caseInquire.postalcode;
    self.textinquiry_note.text = self.caseInquire.inquiry_note;
    [[AppDelegate App] saveContext];
}


//add by nx 2013.11.26
#pragma mark - CasePrintProtocol
- (NSString *)templateNameKey
{
    return DocNameKeyPei_AnJianXunWenBiLu;
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
    NSDate *date;
    NSString *dateString = @"";
    NSString *address = @"";
    NSString *inquirerName = @"";
    NSString *recorderName = @"";
    NSString *answererName = @"";
    NSString *answererSex = @"";
    NSString *answererAge = @"";
    NSString *answererRelation = @"";
    NSString *answererOrgDuty = @"";
    NSString *answererPhoneNum = @"";
    NSString *answererAddress = @"";
    NSString *answererPostalCode = @"";
    NSString *inquireNote1 = @"";
    NSString *inquireNote2 = @"";
    NSString *inquireNote3 = @"";
    NSString *inquireNote4 = @"";
    NSString *pagesCount = @"";
    NSString *pageNum = @"";
    NSString *idCard = @"";
    NSString *orgName = @"";
    NSString *inquirerAndRecorder = @"";
    NSString *inquirerRecorderID = @"";
    NSString *inquireNotequestionone = @"";
    
    self.caseInquire = [CaseInquire inquireForCase:self.caseID];
    if (self.caseInquire) {
        date = self.caseInquire.date_inquired;
        address = NSStringNilIsBad(self.caseInquire.locality);
        inquirerName = NSStringNilIsBad(self.caseInquire.inquirer_name);
        recorderName = NSStringNilIsBad(self.caseInquire.recorder_name);
        answererName = NSStringNilIsBad(self.textanswerer_name.text);
        answererRelation = NSStringNilIsBad(self.caseInquire.relation);
        answererPhoneNum = NSStringNilIsBad(self.caseInquire.phone);
        inquireNote1 = NSStringNilIsBad(self.textQuestion1.text);
        inquireNote2 = NSStringNilIsBad(self.textQuestion2.text);
        inquireNote3 = NSStringNilIsBad(self.textQuestion3.text);
        inquireNote4 = NSStringNilIsBad(self.textQuestion4.text);
        answererOrgDuty = NSStringNilIsBad(self.caseInquire.company_duty);
        inquireNotequestionone = NSStringNilIsBad(self.inquireNotequestionone.text);


        pageNum = @"1";
    }
    
    if (![inquirerName isEmpty]) {
        orgName = [UserInfo orgNameForUserName:inquirerName];
        inquirerRecorderID = [UserInfo exelawIDForUserName:inquirerName];
        if ([inquirerName isEqualToString:recorderName]) {
            inquirerAndRecorder = inquirerName;
        }else{
            inquirerAndRecorder = [NSString stringWithFormat:@"%@、%@",inquirerName,recorderName];
        inquirerRecorderID = [inquirerRecorderID stringByAppendingFormat:@"、%@",[UserInfo exelawIDForUserName:recorderName]];
        }
    }
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    dateString =[dateFormatter stringFromDate:date];
    if (dateString == nil) {
        dateString = @"";
    }
    Citizen *citizen = [Citizen citizenByCitizenName:self.caseInquire.answerer_name nexus:self.caseInquire.relation case:self.caseID];
    if (citizen != nil) {
        answererSex = NSStringNilIsBad(citizen.sex);
        answererAge = NSStringNilIsBad((NSString *)citizen.age);
        answererAddress = NSStringNilIsBad(citizen.address);
        answererPostalCode = NSStringNilIsBad(citizen.postalcode);
        idCard = NSStringNilIsBad(citizen.card_no);
    }
    id caseInquireData = @{
                           @"date":dateString,
                           @"place":address,
                           @"inquirerName":inquirerName,
                           @"recorderName":recorderName,
                           @"orgName":orgName,
                           @"inquirerAndRecorder":inquirerAndRecorder,
                           @"inquirerRecorderID":inquirerRecorderID,
                           @"answererName":answererName,
                           @"answererSex":answererSex,
                           @"answererAge":answererAge,
                           @"answererRelation":answererRelation,
                           @"answererOrgDuty":answererOrgDuty,
                           @"answererPhoneNum":answererPhoneNum,
                           @"answererAddress":answererAddress,
                           @"answererPostalCode":answererPostalCode,
                           @"inquireNote1":inquireNote1,
                           @"inquireNote2":inquireNote2,
                           @"inquireNote3":inquireNote3,
                           @"inquireNote4":inquireNote4,
                           @"card":idCard,
                           @"inquireNotequestionone":inquireNotequestionone
                           };
    
    id page = @{
                @"pageCount":pagesCount,
                @"pageNum":pageNum
                };
    
    id data = @{
                @"case": caseData,
                @"caseInquire": caseInquireData,
                @"page":page
                };
    
    return data;
}





- (NSArray *)pagesSplitted {
    NSString *inquiryNote = self.caseInquire.inquiry_note;
    
    CGFloat fontSize1 = [self fontSizeInPage:kPageInfoFirstPage];
    CGFloat lineHeight1 = [self lineHeightInPage:kPageInfoFirstPage];
    UIFont *font1 = [UIFont fontWithName:FONT_FangSong size:fontSize1];
    CGRect page1Rect = [self rectInPage:kPageInfoFirstPage];
    
    CGFloat fontSize2 = [self fontSizeInPage:kPageInfoSucessivePage];
    CGFloat lineHeight2 = [self lineHeightInPage:kPageInfoSucessivePage];
    UIFont *font2 = [UIFont fontWithName:FONT_FangSong size:fontSize2];
    CGRect page2Rect = [self rectInPage:kPageInfoSucessivePage];
    
    NSArray *pages = [inquiryNote pagesWithFont:font1 lineHeight:lineHeight1 horizontalAlignment:UITextAlignmentLeft page1Rect:page1Rect followPageRect:page2Rect];
    
    if ([pages count] > 2) {
        NSString *textInFirstPage = pages[kPageInfoFirstPage];
        NSRange firstpageRange = NSMakeRange(0, [textInFirstPage length]);
        NSString *textInSuccessivePage = [inquiryNote stringByReplacingCharactersInRange:firstpageRange withString:@""];
        NSArray *successivePages = [textInSuccessivePage pagesWithFont:font2 lineHeight:lineHeight2 horizontalAlignment:UITextAlignmentLeft page1Rect:page2Rect followPageRect:page2Rect];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        [tempArr addObject:pages[kPageInfoFirstPage]];
        for (NSUInteger i = 0; i < [successivePages count]; i++) {
            [tempArr addObject:successivePages[i]];
        }
        pages = [tempArr copy];
    }
    return pages;
}
- (CGFloat)fontSizeInPage:(NSInteger)pageNo {
    NSString *xmlPathString = nil;
    if (pageNo == kPageInfoFirstPage) {
        xmlPathString = [super xmlStringFromFile:xmlName];
    } else if (pageNo >= kPageInfoSucessivePage) {
        xmlPathString = [super xmlStringFromFile:secondPageXmlName];
    }
    NSError *err;
    TBXML *xmlTree = [TBXML newTBXMLWithXMLString:xmlPathString error:&err];
    NSAssert(err==nil, @"Fail when creating TBXML object: %@", err.description);
    
    TBXMLElement *root = xmlTree.rootXMLElement;
    NSArray *elementsWrapped = [TBXML findElementsFrom:root byDotSeparatedPath:@"DataTable.UITextView" withPredicate:@"content.data.attributeName = inquiry_note"];
    NSAssert([elementsWrapped count]>0, @"Element not found.");
    
    NSValue *elementWrapped = elementsWrapped[0];
    TBXMLElement *inqurynoteElement = elementWrapped.pointerValue;
    
    TBXMLElement *fontSizeElement = [TBXML childElementNamed:@"fontSize" parentElement:inqurynoteElement error:&err];
    NSAssert(err==nil, @"Fail when looking up child element: %@", err.description);
    
    return [[TBXML textForElement:fontSizeElement] floatValue];
}

- (CGFloat)lineHeightInPage:(NSInteger)pageNo {
    NSString *xmlPathString = nil;
    if (pageNo == kPageInfoFirstPage) {
        xmlPathString = [super xmlStringFromFile:xmlName];
    } else if (pageNo >= kPageInfoSucessivePage) {
        xmlPathString = [super xmlStringFromFile:secondPageXmlName];
    }
    NSError *err;
    TBXML *xmlTree = [TBXML newTBXMLWithXMLString:xmlPathString error:&err];
    NSAssert(err==nil, @"Fail when creating TBXML object: %@", err.description);
    
    TBXMLElement *root = xmlTree.rootXMLElement;
   NSArray *elementsWrapped = [TBXML findElementsFrom:root byDotSeparatedPath:@"DataTable.UITextView" withPredicate:@"content.data.attributeName = inquiry_note"];
    NSAssert([elementsWrapped count]>0, @"Element not found.");
    
    NSValue *elementWrapped = elementsWrapped[0];
    TBXMLElement *inqurynoteElement = elementWrapped.pointerValue;
    
    TBXMLElement *lineHeightElement = [TBXML childElementNamed:@"lineHeight" parentElement:inqurynoteElement error:&err];
    NSAssert(err==nil, @"Fail when looking up child element: %@", err.description);
    
    return [[TBXML textForElement:lineHeightElement] floatValue];
}


- (CGRect)rectInPage:(NSInteger)pageNo {
    NSString *xmlPathString = nil;
    if (pageNo == kPageInfoFirstPage) {
        xmlPathString = [super xmlStringFromFile:xmlName];
    } else if (pageNo >= kPageInfoSucessivePage) {
        xmlPathString = [super xmlStringFromFile:secondPageXmlName];
    }
    NSError *err;
    TBXML *xmlTree = [TBXML newTBXMLWithXMLString:xmlPathString error:&err];
    NSAssert(err==nil, @"Fail when creating TBXML object: %@", err.description);
    
    TBXMLElement *root = xmlTree.rootXMLElement;
    NSArray *elementsWrapped = [TBXML findElementsFrom:root byDotSeparatedPath:@"DataTable.UITextView" withPredicate:@"content.data.attributeName = inquiry_note"];
    NSAssert([elementsWrapped count]>0, @"Element not found.");
    
    NSValue *elementWrapped = elementsWrapped[0];
    TBXMLElement *inqurynoteElement = elementWrapped.pointerValue;
    
    TBXMLElement *sizeElement = [TBXML childElementNamed:@"size" parentElement:inqurynoteElement error:&err];
    NSAssert(err==nil, @"Fail when looking up child element: %@", err.description);
    
    TBXMLElement *originElement = [TBXML childElementNamed:@"origin" parentElement:inqurynoteElement error:&err];
    NSAssert(err==nil, @"Fail when looking up child element: %@", err.description);
    
    NSAssert(sizeElement != nil && originElement != nil, @"Fail when looking up child element 'size' or 'origin'");
    
    CGFloat x = [[TBXML valueOfAttributeNamed:@"x" forElement:originElement] floatValue] * MMTOPIX * SCALEFACTOR;
    CGFloat y = [[TBXML valueOfAttributeNamed:@"y" forElement:originElement] floatValue] * MMTOPIX * SCALEFACTOR;
    CGFloat width = [[TBXML valueOfAttributeNamed:@"width" forElement:sizeElement] floatValue] * MMTOPIX * SCALEFACTOR;
    CGFloat height = [[TBXML valueOfAttributeNamed:@"height" forElement:sizeElement] floatValue] * MMTOPIX * SCALEFACTOR;
    return CGRectMake(x, y, width, height);
}
- (NSMutableDictionary *)getDataInfo{
    // dataInfo用法:
    // (1) id value = dataInfo[实体名][属性名][@"value"]
    // (2) NSAttributeDescription *desc = dataInfo[实体名][属性名][@"valueType"]
    // (3) dataInfo[@"Default"]针对XML中未指名实体的项
    NSMutableDictionary *dataInfo = [[NSMutableDictionary alloc] init];
    
    //将CaseInquire的属性名、属性值、属性描述装入dataInfo
    NSMutableDictionary *caseInquireDataInfo = [[NSMutableDictionary alloc] init];
    NSDictionary *caseInquireAttributes = [self.caseInquire.entity attributesByName];
    for (NSString *attribName in caseInquireAttributes.allKeys) {
        id attribValue = [self.caseInquire valueForKey:attribName];
        NSAttributeDescription *attribDesc = [caseInquireAttributes objectForKey:attribName];
        NSAttributeType attribType = attribDesc.attributeType;
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     attribValue,@"value",
                                     @(attribType),@"valueType",nil];
        [caseInquireDataInfo setObject:data forKey:attribName];
        
    }
    
    //将CaseInfo的属性名、属性值、属性描述装入dataInfo
    CaseInfo *relativeCaseInfo = [CaseInfo caseInfoForID:self.caseID];
    NSMutableDictionary *caseInfoDataInfo = [[NSMutableDictionary alloc] init];
    NSDictionary *caseInfoAttributes = [relativeCaseInfo.entity attributesByName];
    for (NSString *attribName in caseInfoAttributes.allKeys) {
        id attribValue = [relativeCaseInfo valueForKey:attribName];
        NSAttributeDescription *attribDesc = [caseInfoAttributes objectForKey:attribName];
        NSAttributeType attribType = attribDesc.attributeType;
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     attribValue,@"value",
                                     @(attribType),@"valueType",nil];
        [caseInfoDataInfo setObject:data forKey:attribName];
    }
    
    //设置一个Default（针对xml里没有entityName的节点），指向caseInquireDataInfo
    [dataInfo setObject:caseInquireDataInfo forKey:@"Default"];
    [dataInfo setObject:caseInquireDataInfo forKey:[self.caseInquire.entity name]];
    
    [dataInfo setObject:caseInfoDataInfo forKey:[relativeCaseInfo.entity name]];
    
    //预留页码位置
    NSMutableDictionary *pageCountInfo = [[NSMutableDictionary alloc] init];
    [pageCountInfo setObject:@(NSInteger32AttributeType) forKey:@"valueType"];
    NSMutableDictionary *pageNumberInfo = [[NSMutableDictionary alloc] init];
    [pageNumberInfo setObject:@(NSInteger32AttributeType) forKey:@"valueType"];
    [dataInfo setObject:[@{@"pageCount":pageCountInfo, @"pageNumber":pageNumberInfo} mutableCopy]
                 forKey:@"PageNumberInfo"];
    
    return dataInfo;
}


#pragma mark - CasePrintProtocol


#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 100:
//        case 101:
        case 200:
        case 201:
//        case 202:
            return NO;
            break;
        default:
            return YES;
            break;
    }
}

- (IBAction)userSelect:(UITextField *)sender {
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
        self.textinquirer_name.text = name;
    }else if (self.textFieldTag == 201){
        self.textrecorder_name.text = name;
    }
}

- (IBAction)selectDateAndTime:(id)sender {
    UITextField *textField = (UITextField *)sender;
    switch (textField.tag) {
        case 100:
            [self performSegueWithIdentifier:@"toDateTimePicker" sender:self];
            break;
        default:
            break;
    }
}

-(void)setDate:(NSString *)dateString
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date =[dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    self.textdate_inquired.text = [dateFormatter stringFromDate:date];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *segueIdentifier= [segue identifier];
    if ([segueIdentifier isEqualToString:@"toDateTimePicker"]) {
        DateSelectController *dsVC=segue.destinationViewController;
        dsVC.dateselectPopover=[(UIStoryboardPopoverSegue *) segue popoverController];
        dsVC.delegate=self;
        dsVC.pickerType=1;
        dsVC.datePicker.maximumDate=[NSDate date];
        if (self.textdate_inquired.text != nil) {
            [dsVC showdate:self.textdate_inquired.text];
        }
    }
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    switch (textView.tag) {
        case 301:
            self.currentTextView = 1;
            [self pickerPresentForIndex:3 fromRect:textView.frame];
            return YES;
            break;
            
        case 302:
            self.currentTextView = 2;
            [self pickerPresentForIndex:3 fromRect:textView.frame];
            return YES;
            break;
            
        case 303:
            self.currentTextView = 3;
            [self pickerPresentForIndex:3 fromRect:textView.frame];
            return YES;
            break;
            
        case 304:
            self.currentTextView = 4;
            [self pickerPresentForIndex:3 fromRect:textView.frame];
            return YES;
            break;
            
        default:
            return YES;
            break;
    }
}

//弹窗
-(void)pickerPresentForIndex:(NSInteger )pickerType fromRect:(CGRect)rect{
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        AnswererPickerViewController *pickerVC=[[AnswererPickerViewController alloc] initWithStyle:
                                                UITableViewStylePlain];
        pickerVC.pickerType=pickerType;
        pickerVC.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:pickerVC];
//        if (pickerType == 0 || pickerType == 1 ) {
//            pickerVC.tableView.frame=CGRectMake(0, 0, 140, 176);
//            self.pickerPopover.popoverContentSize=CGSizeMake(140, 176);
//        }
        if (pickerType == 2 || pickerType ==3) {
            pickerVC.tableView.frame=CGRectMake(0, 0, 388, 280);
            [pickerVC.tableView setRowHeight:70];
            self.pickerPopover.popoverContentSize=CGSizeMake(388, 280);
        }
        [_pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        pickerVC.pickerPopover=self.pickerPopover;
    }
}

//在光标位置插入文字
-(void)insertString:(NSString *)insertingString intoTextView:(UITextView *)textView
{
    NSRange range = textView.selectedRange;
    if (range.location != NSNotFound) {
        NSString * firstHalfString = [textView.text substringToIndex:range.location];
        NSString * secondHalfString = [textView.text substringFromIndex: range.location];
        textView.scrollEnabled = NO;  // turn off scrolling
        
        textView.text=[NSString stringWithFormat:@"%@%@%@",
                       firstHalfString,
                       insertingString,
                       secondHalfString
                       ];
        range.location += [insertingString length];
        textView.selectedRange = range;
        textView.scrollEnabled = YES;  // turn scrolling back on.
    } else {
        textView.text = [textView.text stringByAppendingString:insertingString];
        [textView becomeFirstResponder];
    }
}


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
//    [self insertString:cell.textLabel.text intoTextView:self.textQuestion1];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


-(void)setNexusDelegate:(NSString *)aText
{
    
}
-(void)setAnswererDelegate:(NSString *)aText
{
    
}

//返回问题编号
-(NSString *)getAskIDDelegate{
    return nil;
}

-(void)setAnswerSentence:(NSString *)answerSentence
{

    switch (self.currentTextView) {
        case 1:
            [self insertString:answerSentence intoTextView:self.textQuestion1];
            break;
        case 2:
            [self insertString:answerSentence intoTextView:self.textQuestion2];
            break;
        case 3:
            [self insertString:answerSentence intoTextView:self.textQuestion3];
            break;
        case 4:
            [self insertString:answerSentence intoTextView:self.textQuestion4];
            break;
        default:
            break;
    }
    
}
//多车辆中的选择车辆
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
-(void)setAutoNumberText:(NSString *)citizen_name{
    [self.citizenNamePicker dismissPopoverAnimated:YES];
    _party = citizen_name;
    [self getCaseProveInfo:citizen_name];
    //生成caseInquire
    [self testAndBuildInquireInfo];
    //从caseInquire中取出数据（若存在），填入页面
    [self getInquireInfoFillInTheBlank];
    
}
-(CaseProveInfo *)getCaseProveInfo:(NSString*)citizen_name{
    self.caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID withCitizenName:citizen_name];
    _relation = @"当事人";
    _party = self.caseProveInfo.citizen_name;
    
    if(self.caseProveInfo == nil){
        self.caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID withInvitee:citizen_name];
        _relation = @"被邀请人";
        _party = self.caseProveInfo.invitee;
    }
    if(self.caseProveInfo == nil){
        self.caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID withOrganizer:citizen_name];
        _relation = @"当事人代表";
        _party = self.caseProveInfo.organizer;
    }
    return self.caseProveInfo;
}
@end
