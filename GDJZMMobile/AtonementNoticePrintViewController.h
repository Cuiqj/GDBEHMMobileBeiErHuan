//
//  AtonementNoticePrintViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-29.
//
//

#import "CasePrintViewController.h"
#import "AutoNumerPickerViewController.h"
@interface AtonementNoticePrintViewController : CasePrintViewController<AutoNumberPickerDelegate,UITextFieldDelegate>



@property (weak, nonatomic) IBOutlet UILabel *labelCaseCode;
@property (weak, nonatomic) IBOutlet UITextField *textBankName;
@property (weak, nonatomic) IBOutlet UITextField *textRoadSegment;
@property (weak, nonatomic) IBOutlet UITextField *textSide;
@property (weak, nonatomic) IBOutlet UITextField *textPlace;
@property (weak, nonatomic) IBOutlet UITextField *textStationKM;
@property (weak, nonatomic) IBOutlet UITextField *textStationM;
@property (weak, nonatomic) IBOutlet UITextField *textYear;
@property (weak, nonatomic) IBOutlet UITextField *textMonth;
@property (weak, nonatomic) IBOutlet UITextField *textDay;
@property (weak, nonatomic) IBOutlet UITextField *textAutomobileNumber;

@property (weak, nonatomic) IBOutlet UITextField *textPay_mode;
@property (weak, nonatomic) IBOutlet UITextField *textcasereason;
@property (weak, nonatomic) IBOutlet UITextField *anyoutext;
@property (weak, nonatomic) IBOutlet UITextField *textadress;
@property (weak, nonatomic) IBOutlet UITextField *citizenparty;

//第几联
@property (weak, nonatomic) IBOutlet UITextField *textlian;

- (IBAction)touchdownlian:(id)sender;
//选择第几联
- (void)setSelectData:(NSString *)data;
//选择车辆
- (IBAction)showAutoNumerPicker:(id)sender;
@end
