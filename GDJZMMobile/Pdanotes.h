//
//  Pdanotes.h
//  GDBEHMMobile
//
//  Created by yu hongwu on 14-8-12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface Pdanotes : BaseManageObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * classe;
@property (nonatomic, retain) NSString * carname;
@property (nonatomic, retain) NSString * recorder;
@property (nonatomic, retain) NSDate * record_date;
@property (nonatomic, retain) NSString * note_desc;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * isPdaFlag;
@property (nonatomic, retain) NSNumber * isuploaded;
+ (NSArray *)getNowPdanotes:(NSString *)classe carCode:(NSString*)carcode;
@end
