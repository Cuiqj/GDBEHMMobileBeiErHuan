//
//  InspectionLight.m
//  GDBEHMMobile
//
//  Created by yu hongwu on 14-8-12.
//
//

#import "InspectionLight.h"


@implementation InspectionLight

@dynamic inspectionid;
@dynamic check_date;
@dynamic mainlight_east;
@dynamic mainlight_west;
@dynamic otherlight;
@dynamic box;
@dynamic remark;
@dynamic isuploaded;
@dynamic myid;
- (NSString *) signStr{
    if (![self.myid isEmpty]) {
        return [NSString stringWithFormat:@"myid == %@", self.myid];
    }else{
        return @"";
    }
}

+ (NSArray *)inspectionLightForID:(NSString *)inspectionID{
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
