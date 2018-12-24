//
//  RecordMadeOnScenePrintViewController.h
//  GDBEHMMobile
//
//  Created by niexin on 12/2/13.
//
//

#import "CasePrintViewController.h"
#import "UserPickerViewController.h"
#import "AutoNumerPickerViewController.h"

@interface RecordMadeOnScenePrintViewController : CasePrintViewController <UserPickerDelegate,AutoNumberPickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textLocation;
@property (weak, nonatomic) IBOutlet UITextField *textEnforceYear;
@property (weak, nonatomic) IBOutlet UITextField *textEnforceMonth;
@property (weak, nonatomic) IBOutlet UITextField *textEnforceDay;
@property (weak, nonatomic) IBOutlet UITextField *textEnforceHour;
@property (weak, nonatomic) IBOutlet UITextField *textEnforceMinute;

//执法人员1名字
@property (weak, nonatomic) IBOutlet UITextField *textEnforcerName1;
//执法人员1名字
@property (weak, nonatomic) IBOutlet UITextField *textEnforcerName2;
//执法人员3名字
@property (weak, nonatomic) IBOutlet UITextField *textEnforcerName3;
//执法证号1
@property (weak, nonatomic) IBOutlet UITextField *textEnforcerNumber1;
//执法证号2
@property (weak, nonatomic) IBOutlet UITextField *textEnforcerNumber2;
//执法证号3
@property (weak, nonatomic) IBOutlet UITextField *textEnforcerNumber3;
@property (weak, nonatomic) IBOutlet UITextField *textRecorderName;

@property (weak, nonatomic) IBOutlet UITextField *textSpoterName;
@property (weak, nonatomic) IBOutlet UITextField *textSpoterID;
@property (weak, nonatomic) IBOutlet UITextField *textSpoterCompanyAndDuty;
@property (weak, nonatomic) IBOutlet UITextField *textSpoterAddress;
@property (weak, nonatomic) IBOutlet UITextField *textSpoterAutomobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *textSpoterProjectName;
@property (weak, nonatomic) IBOutlet UITextField *textSpoterNexus;
@property (weak, nonatomic) IBOutlet UITextField *textSpoterPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *textSpoterAutomobilePattern;

//在检查中发现“内容”
@property (weak, nonatomic) IBOutlet UITextView *textContent;
@property (weak, nonatomic) IBOutlet UITextField *textRemark;



@property (nonatomic, assign) int textFieldTag;

- (IBAction)userSelected:(UITextField *)sender;

- (IBAction)showCitizenNamePicker:(id)sender;


@end
