//
//  CaseSpotRecord.m
//  GDBEHMMobile
//
//  Created by niexin on 12/4/13.
//
//

#import "CaseSpotRecord.h"


@implementation CaseSpotRecord

@dynamic caseinfo_id;
@dynamic address;
@dynamic time;
@dynamic man1;
@dynamic man2;
@dynamic man3;
@dynamic content;
@dynamic remark;
@dynamic recorder;
@dynamic num1;
@dynamic num2;
@dynamic num3;
@dynamic isuploaded;


- (NSString *) signStr{
    if (![self.caseinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"caseinfo_id == %@", self.caseinfo_id];
    }else{
        return @"";
    }
}

+(CaseSpotRecord *)spotRecordForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSPredicate *predicate;
    predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *tempArray=[context executeFetchRequest:fetchRequest error:nil];
    if (tempArray && [tempArray count]>0) {
        return [tempArray objectAtIndex:0];
    }else{
        return nil;
    }
}






@end
