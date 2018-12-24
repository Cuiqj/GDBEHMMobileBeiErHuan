//
//  ParkingNode.h
//  GDRMMobile
//
//  Created by Sniper One on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface ParkingNode : BaseManageObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * date_end;
@property (nonatomic, retain) NSDate * date_send;
@property (nonatomic, retain) NSDate * date_start;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString *fNo;          //厂牌型号
@property (nonatomic, retain) NSString *limitday;
@property (nonatomic, retain) NSString *department;
@property (nonatomic, retain) NSString *departmentaddress;
@property (nonatomic, retain) NSString *telephone;
@property (nonatomic, retain) NSString *dNo;    //驾驶证号
@property (nonatomic, retain) NSString *relation;   //车辆驾驶人与车辆所有人关系
@property (nonatomic, retain) NSString *ownerorg;   //车辆所有人单位
@property (nonatomic, retain) NSString *ownerorgaddress;    //车辆所有人单位地址
@property (nonatomic, retain) NSString *name;   //执法人员姓名
@property (nonatomic, retain) NSString *rowguid;

@property (nonatomic, retain) NSString *happenplace;    //案发地点，由xx公路和xx处组成



+ (void)deleteAllParkingNodeForCase:(NSString *)caseID;
+ (ParkingNode *)parkingNodesForCase:(NSString *)caseID;
+ (ParkingNode *)parkingNodesForCase:(NSString *)caseID withCitizenName:(NSString*)citizen_name;
+ (NSArray *)parkingNodesByCaseID:(NSString *)caseID;
@end
