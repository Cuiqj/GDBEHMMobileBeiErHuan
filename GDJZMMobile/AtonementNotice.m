//
//  AtonementNotice.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "AtonementNotice.h"
#import "Systype.h"
#import "CaseProveInfo.h"
#import "CaseDeformation.h"
#import "CaseInfo.h"

#import "NSNumber+NumberConvert.h"
#define CHINESE_ARRAY @[@"零",@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖"]


@implementation AtonementNotice

@dynamic myid;
@dynamic caseinfo_id;
//是车牌
@dynamic citizen_name;
@dynamic code;
@dynamic date_send;
@dynamic check_organization;
@dynamic case_desc;
@dynamic witness;
@dynamic pay_reason;
@dynamic pay_mode;
@dynamic organization_id;
@dynamic remark;
@dynamic isuploaded;

- (NSString *) signStr{
    if (![self.caseinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"caseinfo_id == %@", self.caseinfo_id];
    }else{
        return @"";
    }
}

+ (NSArray *)AtonementNoticesForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    return [context executeFetchRequest:fetchRequest error:nil];
}
+ (NSArray *)AtonementNoticesForCase:(NSString *)caseID withCitizenName:citizen_name{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@ AND citizen_name == %@",caseID,citizen_name];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    return [context executeFetchRequest:fetchRequest error:nil];
}
- (NSString *)organization_info{
    return self.organization_id;
}
- (NSString *)adress_notice{
    CaseInfo * caseinfo = [CaseInfo caseInfoForID:self.caseinfo_id];
    NSString * adress = [NSString stringWithFormat:@"%@往%@方向",caseinfo.side,caseinfo.place];
    if([caseinfo.station_start integerValue] != 0)
        adress = [NSString stringWithFormat:@"%@K%@+%@M",adress,[caseinfo station_start_km],[caseinfo station_start_m]];
    return adress;
}
- (NSString *)pay_mode_num{
    NSArray * deformations = [CaseDeformation deformationsForCase:self.caseinfo_id];
    double summary=[[deformations valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    return [NSString stringWithFormat:@"%.2f",summary];
}
- (NSString *)bank_name{
    return [[Systype typeValueForCodeName:@"交款地点"] objectAtIndex:0];
}
- (NSString *)bank_name_ago{
    NSString * bank_name = [[Systype typeValueForCodeName:@"交款地点"] objectAtIndex:0];
    return [bank_name substringToIndex:8];
}
- (NSString *)bank_name_later{
    NSString * bank_name = [[Systype typeValueForCodeName:@"交款地点"] objectAtIndex:0];
    return [bank_name substringFromIndex:8];
}
- (NSString *)case_long_desc_small{
    CaseProveInfo * prove = [CaseProveInfo proveInfoForCase:self.caseinfo_id];
    if ([prove.case_short_desc containsString:@"损坏"] && [prove.case_short_desc containsString:@"污染"]) {
        return @"损坏、污染";
    }else if ([prove.case_short_desc containsString:@"损坏"] && ![prove.case_short_desc containsString:@"污染"]){
        return @"损坏";
    }else if (![prove.case_short_desc containsString:@"损坏"] && [prove.case_short_desc containsString:@"污染"]){
        return @"污染";
    }
    return prove.case_short_desc;
}

-(NSString *)chinese_sum_Ww{
    return [self chinese_sum_result:100000000];
}
-(NSString *)chinese_sum_Qw{
    return [self chinese_sum_result:10000000];
}
-(NSString *)chinese_sum_Bw{
    return [self chinese_sum_result:1000000];
}
-(NSString *)chinese_sum_Sw{
    return [self chinese_sum_result:100000];
}
-(NSString *)chinese_sum_w{
    return [self chinese_sum_result:10000];
}
-(NSString *)chinese_sum_q{
    return [self chinese_sum_result:1000];
}
-(NSString *)chinese_sum_b{
    return [self chinese_sum_result:100];
}
-(NSString *)chinese_sum_s{
    return [self chinese_sum_result:10];
}
-(NSString *)chinese_sum_y{
    return [self chinese_sum_result:1];
}
-(NSString *)chinese_sum_result:(long)num{
    long i;
    double j;
    NSArray * deformations = [CaseDeformation deformationsForCase:self.caseinfo_id];
    double summary=[[deformations valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    j = summary/num/1.0;
    i = summary/num;
    if (i>=1) {
        i = i%10;
        return CHINESE_ARRAY[i];
    }
    if (j>=0.1) {
        return [NSString stringWithFormat:@"￥"];
    }
    return @"";
}

-(NSString *)chinese_sum_j{
    return [self chinese_sum_resultdouble:0.1];
}
-(NSString *)chinese_sum_f{
    return [self chinese_sum_resultdouble:0.01];
}

-(NSString *)chinese_sum_resultdouble:(double)num{

    NSArray * deformations = [CaseDeformation deformationsForCase:self.caseinfo_id];
    double summary=[[deformations valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    if (summary<1) {
        return @"";
    }
    NSString * strsum = [NSString stringWithFormat:@"%.2f",summary];
    NSArray * chunt = [strsum componentsSeparatedByString:@"."];
    if ([chunt count] >= 2) {
        NSString * strtemp =[NSString stringWithFormat:@"0.%@",chunt[1]];
        summary = [strtemp doubleValue];
    }
    long i;
    double j;
    j = summary/num/1.0;
    i = summary/num;
    if (i>=1) {
        i = i%10;
        return CHINESE_ARRAY[i];
    }
    return @"零";
}

@end
