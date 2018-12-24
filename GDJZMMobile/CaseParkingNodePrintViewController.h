//
//  CaseParkingNodePrintViewController.h
//  GDXERHMMobile
//
//  Created by XU SHIWEN on 13-9-3.
//
//

#import "CasePrintViewController.h"
#import "ParkingNode.h"
#import "UserPickerViewController.h"
@interface CaseParkingNodePrintViewController : CasePrintViewController<UserPickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldCitizenName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldHappenDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAutomobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPlacePrefix;
@property (weak, nonatomic) IBOutlet UITextField *textFieldStationStart;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCaseShortDescription;
@property (weak, nonatomic) IBOutlet UITextField *textFieldParkingNodeAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPeriodLimit;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOfficeAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelSendDate;

@property (weak, nonatomic) IBOutlet UILabel *lblCarNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblPersonName;
@property (weak, nonatomic) IBOutlet UILabel *lblPersonAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblOfficeName;
@property (weak, nonatomic) IBOutlet UILabel *lblOwnerOfficeAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblOwnerName;
@property (weak, nonatomic) IBOutlet UILabel *lblLicenceNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblRelationShip;
@property (weak, nonatomic) IBOutlet UILabel *lblOwnerAddress;

@property (weak, nonatomic) IBOutlet UILabel *lblHappenPlace;
@property (weak, nonatomic) IBOutlet UILabel *lblStopTime;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldHandleAddress;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldTelePhone;
@property (weak, nonatomic) IBOutlet UILabel *lblDriveSignDate;
@property (weak, nonatomic) IBOutlet UILabel *lblOwnerSignDate;
@property (weak, nonatomic) IBOutlet UILabel *lblEnforceName1;
@property (weak, nonatomic) IBOutlet UILabel *lblEnforceName2;
@property (weak, nonatomic) IBOutlet UILabel *lblEnforceName3;

@property (weak, nonatomic) IBOutlet UILabel *lblEnforceNO1;
@property (weak, nonatomic) IBOutlet UILabel *lblEnforceNO2;
@property (weak, nonatomic) IBOutlet UILabel *lblEnforceNO3;

@property (weak, nonatomic) IBOutlet UITextField *textCarNumber;
@property (weak, nonatomic) IBOutlet UITextField *textLabelType;
@property (weak, nonatomic) IBOutlet UITextField *textCarOwnerName;
@property (weak, nonatomic) IBOutlet UITextField *textCarOwnerAddress;
@property (weak, nonatomic) IBOutlet UITextField *textCarOwnerOrgName;
@property (weak, nonatomic) IBOutlet UITextField *textCarOwnerOrgAddress;
@property (weak, nonatomic) IBOutlet UITextField *textCitizenName;
@property (weak, nonatomic) IBOutlet UITextField *textCitizenDNo;
@property (weak, nonatomic) IBOutlet UITextField *textCitizenAddress;
@property (weak, nonatomic) IBOutlet UITextField *textRelation;
@property (weak, nonatomic) IBOutlet UITextField *textDateStart;
@property (weak, nonatomic) IBOutlet UITextField *textParkingAddress;
@property (weak, nonatomic) IBOutlet UITextField *textPrintDate;

@property (weak, nonatomic) IBOutlet UITextField *textEnforcerName1;
@property (weak, nonatomic) IBOutlet UITextField *textEnforcerName2;
@property (weak, nonatomic) IBOutlet UITextField *textEnforcerName3;

@property (weak, nonatomic) IBOutlet UITextField *textEnforcerNumber1;
@property (weak, nonatomic) IBOutlet UITextField *textEnforcerNumber2;
@property (weak, nonatomic) IBOutlet UITextField *textEnforcerNumber3;

@property (nonatomic, assign) int textFieldTag;

- (IBAction)userSelected:(UITextField *)sender;


- (IBAction)textFieldAutomobileNumber_touched:(UITextField *)sender;
- (IBAction)showAutoNumerPicker:(id)sender;
@end
