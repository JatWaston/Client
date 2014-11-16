//
//  JWNetworking.m
//  JWWidgetFramework
//
//  Created by JatWaston on 14-9-18.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "JWNetworking.h"



@interface JWNetworking()
{
    NSURLConnection *_connection;
    NSMutableData *_downloadData;
    NSTimeInterval _timeoutInterval;
}

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *downloadData;
@property (nonatomic, copy) void (^requestCompleteHandle)(NSData *data, NSError *error);
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@end

@implementation JWNetworking
@synthesize connection = _connection;
@synthesize downloadData = _downloadData;

- (id)init
{
    if (self = [super init])
    {
        _downloadData = [[NSMutableData alloc] init];
        self.timeoutInterval = 30.0f;
    }
    return self;
}

- (void)cancelRequest
{
    [self.connection cancel];
    self.requestCompleteHandle = nil;
}

- (void)requestWithURL:(NSString*)url requestMethod:(JWRequestMethod)method params:(NSDictionary*)paramsDic requestComplete:(void (^)(NSData *data, NSError *error))completeHandle
{
    NSMutableURLRequest *request = nil;
    switch (method)
    {
        case JWRequestMethodGet:
            if (paramsDic)
            {
                NSMutableArray *params = [NSMutableArray array];
                for (NSString *key in [paramsDic allKeys])
                {
                    [params addObject:[NSString stringWithFormat:@"%@=%@",key,[paramsDic valueForKey:key]]];
                }
                NSString *paramsStr = [params componentsJoinedByString:@"&"];
                NSString *urlStr = [url stringByAppendingString:[NSString stringWithFormat:@"?%@",paramsStr]];
                NSLog(@"Get request url:%@",urlStr);
                NSString *endcodingURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endcodingURL]];
            }
            else
            {
                NSString *endcodingURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endcodingURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeoutInterval];
            }
            [request setHTTPMethod:@"GET"];
            break;
        case JWRequestMethodPost:
        {
            NSString *endcodingURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endcodingURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeoutInterval];
            if (paramsDic)
            {
                NSMutableArray *params = [NSMutableArray array];
                for (NSString *key in [paramsDic allKeys])
                {
                    [params addObject:[NSString stringWithFormat:@"%@=%@",key,[paramsDic valueForKey:key]]];
                }
                NSString *bodyStr = [params componentsJoinedByString:@"&"];
                [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
            }
            [request setHTTPMethod:@"POST"];
        }
            break;
        default:
            break;
    }
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    NSLog(@"self.connect = %@",self.connection);
    self.requestCompleteHandle = completeHandle;
#if !(__has_feature(objc_arc))
    [connection release];
#endif
}

/**
 *  传送的数据中带有NSData类型的
 *
 *  @param url     要请求的URL
 *  @param dict    需要携带的参数
 *  @param handler 网络请求结束或者出错的block
 */

- (void)postDataToURL:(NSURL*)url dict:(NSDictionary*)dict completeHandler:(void (^)(NSData *data, NSError *error))handler
{
#if 1
    
    UIImage *yourImage= [UIImage imageNamed:@"bigImage.jpg"];
    NSData *imageData = UIImagePNGRepresentation(yourImage);
    //    NSString *urlString = [NSString stringWithFormat:@"%@test.php", delegate.dataBean.hosterURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"test.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",[NSString stringWithFormat:@"Image Return String: %@", returnString]);
    
    
    //    UIImage *yourImage= [UIImage imageNamed:@"bigImage.jpg"];
    //    NSData *imageData = UIImageJPEGRepresentation(yourImage,1.0f);
    //    NSString *postLength = [NSString stringWithFormat:@"%d", [imageData length]];
    //
    //    // Init the URLRequest
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //    [request setHTTPMethod:@"POST"];
    //    [request setURL:url];
    //    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //    [request setHTTPBody:imageData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
#endif
    self.connection = conn;
    self.requestCompleteHandle = handler;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
    if (self.connection)
    {
        [self.connection cancel];
    }
#if !(__has_feature(objc_arc))
    SAFE_RELEASE(_connect);
    SAFE_RELEASE(_downloadData);
    [super dealloc];
#endif
}

#pragma mark -
#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"connect = %@",connection);
    [_downloadData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.requestCompleteHandle)
    {
        self.requestCompleteHandle(_downloadData,nil);
        self.requestCompleteHandle = nil;
    }
    
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.requestCompleteHandle)
    {
        self.requestCompleteHandle(_downloadData,error);
        self.requestCompleteHandle = nil;
    }
}




@end
