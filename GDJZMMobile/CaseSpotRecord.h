//
//  CaseSpotRecord.h
//  GDBEHMMobile
//
//  Created by niexin on 12/4/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface CaseSpotRecord : BaseManageObject

@property (nonatomic,retain) NSString *caseinfo_id;

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * man1;
@property (nonatomic, retain) NSString * man2;
@property (nonatomic, retain) NSString * man3;
@property (nonatomic, retain) NSString * num1;
@property (nonatomic, retain) NSString * num2;
@property (nonatomic, retain) NSString * num3;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * recorder;
@property (nonatomic, retain) NSNumber * isuploaded;
+(CaseSpotRecord *)spotRecordForCase:(NSString *)caseID;




@end
