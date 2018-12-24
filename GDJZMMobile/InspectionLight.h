//
//  InspectionLight.h
//  GDBEHMMobile
//
//  Created by yu hongwu on 14-8-12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface InspectionLight : BaseManageObject

@property (nonatomic, retain) NSString * inspectionid;
@property (nonatomic, retain) NSDate * check_date;
@property (nonatomic, retain) NSString * mainlight_east;
@property (nonatomic, retain) NSString * mainlight_west;
@property (nonatomic, retain) NSString * otherlight;
@property (nonatomic, retain) NSString * box;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString *myid;
+ (NSArray *)inspectionLightForID:(NSString *)inspectionID;
@end
