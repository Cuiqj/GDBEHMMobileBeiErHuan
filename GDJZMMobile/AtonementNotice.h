//
//  AtonementNotice.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface AtonementNotice : BaseManageObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * date_send;
@property (nonatomic, retain) NSString * check_organization;
@property (nonatomic, retain) NSString * case_desc;
@property (nonatomic, retain) NSString * witness;
@property (nonatomic, retain) NSString * pay_reason;
@property (nonatomic, retain) NSString * pay_mode;
@property (nonatomic, retain) NSString * organization_id;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * isuploaded;

+ (NSArray *)AtonementNoticesForCase:(NSString *)caseID;
+ (NSArray *)AtonementNoticesForCase:(NSString *)caseID withCitizenName:citizen_name;
- (NSString *)organization_info;

- (NSString *)bank_name;

- (NSString *)bank_name_ago;
- (NSString *)bank_name_later;
- (NSString *)case_long_desc_small;

- (NSString *)pay_mode_num;
- (NSString *)adress_notice;


-(NSString *)chinese_sum_Ww;
-(NSString *)chinese_sum_Qw;
-(NSString *)chinese_sum_Bw;
-(NSString *)chinese_sum_Sw;

-(NSString *)chinese_sum_w;
-(NSString *)chinese_sum_q;
-(NSString *)chinese_sum_b;
-(NSString *)chinese_sum_s;
-(NSString *)chinese_sum_y;
-(NSString *)chinese_sum_j;
-(NSString *)chinese_sum_f;

@end
