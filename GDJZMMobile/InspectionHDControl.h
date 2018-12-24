//
//  InspectionHDControl.h
//  GDBEHMMobile
//
//  Created by yu hongwu on 14-9-9.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface InspectionHDControl : BaseManageObject

@property (nonatomic, retain) NSString * inspectionid;
@property (nonatomic, retain) NSDate * checkdate;
@property (nonatomic, retain) NSString * mainHD_east;
@property (nonatomic, retain) NSString * mianHD_west;
@property (nonatomic, retain) NSString * mainstatus;
@property (nonatomic, retain) NSString * solution;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSNumber * isuploaded;
+ (NSArray *)InspectionHDControlForID:(NSString *)inspectionID;
@end
