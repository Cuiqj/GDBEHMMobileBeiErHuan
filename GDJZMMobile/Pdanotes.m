//
//  Pdanotes.m
//  GDBEHMMobile
//
//  Created by yu hongwu on 14-8-12.
//
//

#import "Pdanotes.h"


@implementation Pdanotes

@dynamic myid;
@dynamic classe;
@dynamic carname;
@dynamic recorder;
@dynamic record_date;
@dynamic note_desc;
@dynamic remark;
@dynamic isPdaFlag;
@dynamic isuploaded;
+ (NSArray *)getNowPdanotes:(NSString *)classe carCode:(NSString*)carcode{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if (![carcode isEmpty] && ![classe isEmpty]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *now = [formatter stringFromDate:[NSDate date]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSDate *todayBegin= [dateFormatter dateFromString:[now stringByAppendingString:@" 00:00:00" ]];
        NSDate *todayEnd= [dateFormatter dateFromString:[now stringByAppendingString:@" 23:59:59" ]];
        [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"carname == %@ and classe == %@ and record_date >= %@ and record_date <= %@",carcode,classe,todayBegin,todayEnd]];
    }
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
