//
//  CaseInquire.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-19.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"
//询问笔录
@interface CaseInquire : BaseManageObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * answerer_name;
@property (nonatomic, retain) NSString * proveinfo_id;
@property (nonatomic, retain) NSString * company_duty;
@property (nonatomic, retain) NSDate * date_inquired;
@property (nonatomic, retain) NSString * inquirer_name;
@property (nonatomic, retain) NSString * inquiry_note;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * locality;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * postalcode;
@property (nonatomic, retain) NSString * recorder_name;
@property (nonatomic, retain) NSString * relation;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * answer1;
@property (nonatomic, retain) NSString * answer2;
@property (nonatomic, retain) NSString * answer3;
@property (nonatomic, retain) NSString * answer4;

+(CaseInquire *)inquireForCase:(NSString *)caseID;
+(CaseInquire *)inquireForCase:(NSString *)caseID withAnswererName:answererName;
@end
