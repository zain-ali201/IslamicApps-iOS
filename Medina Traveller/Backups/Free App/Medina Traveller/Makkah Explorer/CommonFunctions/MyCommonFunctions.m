//
//  MyCommonFunctions.h.m
//  Snaprint
//
//  Created by Zain Ali on 2/10/13.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "MyCommonFunctions.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyCommonFunctions

#define databaseName @"MakkahExplorer.sqlite"
static sqlite3 *database = nil;

#pragma mark -
#pragma mark DB_STUFF

+(void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
    NSLog(@"DB Path: %@", dbPath);
	
	if(!success) {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
		//		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AnwaltTestDB.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

+(NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	//NSLog(@"%@",documentsDir);
	//	return [documentsDir stringByAppendingPathComponent:@"AnwaltTestDB.sqlite"];
	return [documentsDir stringByAppendingPathComponent:databaseName];
}

+(NSString *) getDBPathForSql {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:databaseName];
}

+(void) genrateDB {
	NSString *dbFilePath = [self getDBPath];
	if(sqlite3_open([dbFilePath UTF8String], &database) == SQLITE_OK)
	{
		NSLog(@"CONNECTION SUCCESSFUL WITH DB");
	}
	else
	{
		NSLog(@"CONNECTION FAILURE WITH DB");
	}
	
}

+(sqlite3_stmt *) getStatement:(NSString *) SQLStrValue {
	
	NSLog(@"QUERY: %@", SQLStrValue);
	if([SQLStrValue isEqualToString:@""])
		return NO;
	
	sqlite3_stmt * OperationStatement;
	sqlite3_stmt * ReturnStatement = nil;
	
	
	const char * sql = [SQLStrValue cStringUsingEncoding: NSUTF8StringEncoding];
	if (sqlite3_prepare_v2(database, sql, -1, &OperationStatement, NULL) == SQLITE_OK)
	{
		ReturnStatement = OperationStatement;
	}
	return ReturnStatement;
}

+(BOOL)InsUpdateDelData:(NSString*)SqlStr {
    
	if([SqlStr isEqual:@""])
		return NO;
	
	BOOL RetrunValue;
	RetrunValue = NO;
	const char *sql = [SqlStr cStringUsingEncoding:NSUTF8StringEncoding];
	
    sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(database, sql, -1, &stmt, nil) == SQLITE_OK)
	{
		printf("\n\nSuccess Query: %s\n\n", sql);
		RetrunValue = YES;
	}
	else
	{
		printf("\n\nFailure Query: %s\n\n", sql);
	}
	
	if(RetrunValue == YES)
	{
		
		if(sqlite3_step(stmt) != SQLITE_DONE)
			NSLog(@"This should be real error checking!");
		sqlite3_finalize(stmt);
	}
	
	return RetrunValue;
}

#pragma mark -
#pragma mark PDF_FUNCTIONS

+ (NSString*)downloadAndSavePDFInDocuments:(NSString*)url Name:(NSString*)fileName
{
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *filePath = [documentsDirectory
                          stringByAppendingPathComponent:fileName];
    [pdfData writeToFile:filePath atomically:YES];
    
    return filePath;
}

#pragma mark -
#pragma mark IMAGE_FUNCTIONS

+ (NSString*)saveImageInDocuments:(UIImage*)senderImage name:(NSString*)imageName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
//	NSDate *selected = [NSDate date];
//	
//	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//	[dateFormat setDateFormat:@"ddmmyyyyhhmmss"];
//	NSString *imgName = [dateFormat stringFromDate:selected];
	imageName = [NSString stringWithFormat:@"%@",imageName];

	NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
	
	UIImage *image = senderImage;
	NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
	[imageData writeToFile:savedImagePath atomically:YES];
	return imageName;
}

+ (UIImage*)getImageFromDocuments:(NSString*)senderImageName {
	
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:senderImageName];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL fileExist = [fileManager fileExistsAtPath:getImagePath]; // Returns a BOOL  
	
	UIImage *img = nil;
	if(fileExist)
	{
		img = [[UIImage alloc] init];
		img = [UIImage imageWithContentsOfFile:getImagePath];
	}
	return img;
}

+ (void)removeImageFromDocuments:(NSString*)fileName {
	
	NSFileManager *fileManager = [NSFileManager defaultManager];	 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	 
	NSString *documentsDirectory = [paths objectAtIndex:0];	 
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
	
	[fileManager removeItemAtPath: fullPath error:NULL];
	
	NSLog(@"image removed");
}

+(bool) doesFileExist: (NSString *)filePath 
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

+(NSString*)replaceURLAndRetrunImageName:(NSString*)URL
{
	NSString *strContains = [NSString stringWithFormat:@"/"];
	NSString *currentCharacter = @"";
	for (int i =0; i< [URL length]; i++) {
		unichar ch = [URL characterAtIndex:i];
		NSString *str = [NSString stringWithCharacters:&ch length:1];		
		currentCharacter = [NSString stringWithFormat:@"%@", str];
		if([currentCharacter isEqualToString:strContains])
		{
			URL = [URL substringFromIndex:i+1];
			i = 0;
		}
	}
	return URL;
}

static bool completedOperation;

static UIActivityIndicatorView * activitySpinner;
+(void) stopSpinner
{
	if(activitySpinner && completedOperation)
	{
//		[activitySpinner stopAnimating];
//		[activitySpinner removeFromSuperview];
//		[activitySpinner release];
	}
	else
	{
		[self performSelector:@selector(stopSpinner) withObject:nil afterDelay:1.0];
	}
}

+(void) startSpinner
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	if(!completedOperation)
	{	

	}
	
	[pool release];
}



+(UIImage *)getOrDownloadImage:(NSString*)photoUrl
{	
	NSString *myImageName = @"";	
	myImageName = [MyCommonFunctions replaceURLAndRetrunImageName:photoUrl];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString * filePath =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", myImageName]];
	UIImage *image = nil;
	
	if(![myImageName isEqualToString:@""])
	{	
		if([self doesFileExist:filePath])
		{
			NSLog(@"Image Found.");
			image = [UIImage imageWithContentsOfFile:filePath];
			return image;
		}
	}
    if ([[NSString stringWithFormat:@"%@",photoUrl] rangeOfString:@"http:"].location != NSNotFound) 
    {
        photoUrl = [NSString stringWithFormat:@"%@",photoUrl];
    }
	else
    {

    }
    
    completedOperation = NO;
    NSThread * t1 = [[NSThread alloc] initWithTarget:self selector:@selector(startSpinner) object:nil];
    [t1 start];
    
	NSData *receivedData = [[NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]] retain];
	if([receivedData length] > 0)
	{        
		NSLog(@"Image downloaded to documents.");
	}
    
    
        completedOperation = YES;
        image = [UIImage  imageWithData:receivedData];		
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
        [imageData writeToFile:filePath atomically:YES];
        
        [self performSelector:@selector(stopSpinner) withObject:nil];
        
//        [t1 cancel];
  //      [t1 release];   
    
   
	return image;
}


+(UIImage *)getOrDownloadGalleryImage:(NSString*)photoUrl
{
	
	NSString *myImageName = @"";	
	myImageName = [MyCommonFunctions replaceURLAndRetrunImageName:photoUrl];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString * filePath =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", myImageName]];
	UIImage *image = nil;
	
	if(![myImageName isEqualToString:@""])
	{	
		if([self doesFileExist:filePath])
		{
			NSLog(@"Image Found.");
			image = [UIImage imageWithContentsOfFile:filePath];
			return image;
		}
	}
	photoUrl = [NSString stringWithFormat:@"%@",photoUrl];
    
    completedOperation = NO;
    NSThread * t1 = [[NSThread alloc] initWithTarget:self selector:@selector(startSpinner) object:nil];
    [t1 start];
    
	NSData *receivedData = [[NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]] retain];
	if([receivedData length] > 0)
	{        
		NSLog(@"Image downloaded to documents.");
	}
    
    
    completedOperation = YES;
    image = [UIImage  imageWithData:receivedData];		
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [imageData writeToFile:filePath atomically:YES];
    
    [self performSelector:@selector(stopSpinner) withObject:nil];
    
    [t1 cancel];
    [t1 release];   
    
    
	return image;
}



#pragma mark -
#pragma mark DATE_FUNCTIONS

/* 
 SAMPLE CODE
 
 NSString *inputDateString = @"2007-08-11T19:30:00Z";
 NSString *outputDateString = [NSDateFormatter
 dateStringFromString:inputDateString
 sourceFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"
 destinationFormat:@"h:mm:ssa 'on' MMMM d, yyyy"];
 */
+ (NSString *)dateStringFromString:(NSString *)sourceString sourceFormat:(NSString *)sourceFormat destinationFormat:(NSString *)destinationFormat
{
	
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:sourceFormat];
    NSDate *date = [dateFormatter dateFromString:sourceString];
    [dateFormatter setDateFormat:destinationFormat];
    return [dateFormatter stringFromDate:date];
}




+ (NSString *)stringWithUrl:(NSURL *)url {
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
												cachePolicy:NSURLRequestReturnCacheDataElseLoad
											timeoutInterval:30];
	// Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
									returningResponse:&response
												error:&error];
	
 	// Construct a String around the Data from the response
	return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

//+ (id) objectWithUrl:(NSURL *)url {
//	//	[self performSelector:@selector(startSpinner) withObject:nil];
//	
//	SBJsonParser *jsonParser = [SBJsonParser new];
//	NSString *jsonString = [self stringWithUrl:url];
//	//	NSLog(@"%@",jsonString);
//	// Parse the JSON into an Object
//	
//	return [jsonParser objectWithString:jsonString error:NULL];
//}
//
//+ (id) objectWthString:(NSString *) jsonString {
//	SBJsonParser *jsonParser = [SBJsonParser new];
//	return [jsonParser objectWithString:jsonString error:NULL];
//}

+(BOOL)contains:(NSString*) strContains InString:(NSString*)targetString {
	//NSNotFound is a built i variable; it's value is 0
	
	if([[NSString stringWithFormat:@"%@", targetString] isEqualToString:@"(null)"] == TRUE)
		return FALSE;
	if([targetString length] == 0)
		return FALSE;
	
	if ([targetString rangeOfString:strContains].location == NSNotFound) {
		return FALSE;
	} else {
		return TRUE;		
	}
}


+(BOOL)isEmailValid:(NSString*)emailAddress
{
	if([[NSString stringWithFormat:@"%@", emailAddress] isEqualToString:@"(null)"] == TRUE)
		return FALSE;
	if([emailAddress length] == 0)
		return FALSE;
		
	NSString *email = [emailAddress lowercaseString];
	NSString *emailRegEx =
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";

	NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
	BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:email];
	if(!myStringMatchesRegEx)
	{		
		return FALSE;
	}
	return TRUE;
}

+ (BOOL)fileExistsInDocumentDirectory:(NSString*)fileName
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager fileExistsAtPath:filePath];
}

+ (NSString*)documentDirectoryFilePath:(NSString*)fileName
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

#pragma mark -
#pragma mark WEBSERVICE CALLING FUNCTIONS

/******* IF YOU HAVE JSON API, JUST UNCOMMENT FOLLOWING FUNCTIONS *******/

//and import #import "JSON.h"

/*
+(NSDictionary*) callWebservice : (NSString*)url
{
    NSDictionary  *dictionary = nil;

    if (url!=nil && ![url isEqualToString:@""]) {
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        NSError *error = nil;
        NSString *resultData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        dictionary = [[[SBJSON alloc] init] objectWithString:resultData error:&error];
    }
    return dictionary;
}

+(NSMutableDictionary*)callWebService:(NSString *)urlString RequestData:(NSDictionary *)postData ImageParameterName:(NSString*)imageName Image:(UIImage*)img
{
    NSURL *url = [[NSURL alloc] initWithString:[[NSString stringWithFormat:@"%@%@",kRootWebServiceURL,urlString ] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ;//[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",apiURL,urlString]];
    
    NSLog(@"url : %@",url);
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:300.];
    
    [req setValue:@"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_7; en-us) AppleWebKit/533.4 (KHTML, like Gecko) Version/4.1 Safari/533.4" forHTTPHeaderField:@"User-Agent"];
    [req setHTTPMethod:@"POST"];
    
    // 1.2 BOUNDARY separator
    
    NSString *boundary = @"0194784892923";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data, boundary=%@", boundary];
    [req setValue:contentType forHTTPHeaderField:@"Content-type"];
    
    // 1.3 build the BODY
    
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if(img)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *imageData = UIImageJPEGRepresentation(img ,0.7);
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", imageName,[formatter stringFromDate:[NSDate date]]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:imageData];
        
    }else
    {
        NSLog(@"No Image....");
    }
    //  NSLog(@"%@",postBody);
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [req setHTTPBody:postBody];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    [req setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    NSString *dataStr=[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    // NSLog(@"DataString : %@",dataStr);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    return (NSMutableDictionary *) [dataStr JSONValue];
}
*/
@end
