//
//  MyCommonFunctions.h.m
//  Snaprint
//
//  Created by Zain Ali on 2/10/13.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kRootURL @""
#define kRootWebServiceURL @""
#import "sqlite3.h"

@interface MyCommonFunctions : NSObject {
}

+(void) copyDatabaseIfNeeded;
+(NSString *) getDBPath;
+(NSString *) getDBPathForSql;
+(void) genrateDB;
+(sqlite3_stmt *) getStatement:(NSString *) SQLStrValue;
+(BOOL)InsUpdateDelData:(NSString*)SqlStr;
+ (NSString*)downloadAndSavePDFInDocuments:(NSString*)url Name:(NSString*)fileName;
+ (NSString*)saveImageInDocuments:(NSString*)senderImage name:(NSString*)imageName;
+ (NSString*)getImageFromDocuments:(NSString*)senderImageName;
+ (void)removeImageFromDocuments:(NSString*)fileName;
+(NSString*)getOrDownloadImage:(NSString*)photoUrl;
+(bool) doesFileExist: (NSString *)filePath;
+ (NSString *)dateStringFromString:(NSString *)sourceString sourceFormat:(NSString *)sourceFormat destinationFormat:(NSString *)destinationFormat;
+(BOOL)contains:(NSString*) strContains InString:(NSString*)targetString;
+(BOOL)isEmailValid:(NSString*)emailAddress;
+(NSString*)replaceURLAndRetrunImageName:(NSString*)URL;
+(NSString *)getOrDownloadGalleryImage:(NSString*)photoUrl;
+(NSDictionary*) callWebservice : (NSString*)url;
+(NSMutableDictionary*)callWebService:(NSString *)urlString RequestData:(NSDictionary *)postData ImageParameterName:(NSString*)imageName Image:(NSString*)img;

+(NSString*)documentDirectoryFilePath:(NSString*)fileName;
+(BOOL)fileExistsInDocumentDirectory:(NSString*)fileName;

@end
