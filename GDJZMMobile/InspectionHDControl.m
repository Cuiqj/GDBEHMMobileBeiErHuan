//
//  InspectionHDControl.m
//  GDBEHMMobile
//
//  Created by yu hongwu on 14-9-9.
//
//

#import "InspectionHDControl.h"


@implementation InspectionHDControl

@dynamic inspectionid;
@dynamic checkdate;
@dynamic mainHD_east;
@dynamic mianHD_west;
@dynamic mainstatus;
@dynamic solution;
@dynamic myid;
@dynamic isuploaded;
- (NSString *) signStr{
    if (![self.myid isEmpty]) {
        return [NSString stringWithFormat:@"myid == %@", self.myid];
    }else{
        return @"";
    }
}

+ (NSArray *)InspectionHDControlForID:(NSString *)inspectionID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if (![inspectionID isEmpty]) {
        [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"inspectionid == %@",inspectionID]];
    }
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
