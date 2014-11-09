//
//  JWNetwork.m
//  NetworkDemo
//
//  Created by JatWaston on 14-7-18.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "JWNetworking.h"

#define SYMBOL @"AaB03x" //分界线的标识符

#if !(__has_feature(objc_arc))

    #define SAFE_RELEASE(OBJ) {if(OBJ) {[OBJ release]; OBJ = nil;}}

#endif

@interface JWNetworking()
{
    NSURLConnection *_connect;
    NSMutableData *_downloadData;
}

@property (nonatomic, retain) NSURLConnection *connect;
@property (nonatomic, retain) NSMutableData *downloadData;

@end

@implementation JWNetworking

@synthesize connect = _connect;
@synthesize downloadData = _downloadData;
@synthesize contentType = _contentType;

- (id)init
{
    if (self = [super init])
    {
        _downloadData = [[NSMutableData alloc] init];
    }
    return self;
}

/**
 *  网络请求方法
 *
 *  @param url     要请求的URL
 *  @param type    GET或者POST方法
 *  @param dict    POST方法是需要携带的参数，GET时候不需要这个参数，可设置为nil
 *  @param handler 网络请求结束或者出错的block
 */

- (void)requestWithURL:(NSURL*)url requestType:(REQUEST_TYPE)type dict:(NSDictionary*)dict completeHandler:(void (^)(NSData *data, NSError *error))handler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    switch (type)
    {
        case METHOD_GET:
            [request setHTTPMethod:@"GET"];
            break;
        case METHOD_POST:
            {
                if (dict)
                {
                    NSMutableArray *params = [NSMutableArray array];
                    for (NSString *key in [dict allKeys])
                    {
                        [params addObject:[NSString stringWithFormat:@"%@=%@",key,[dict valueForKey:key]]];
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
    self.connect = connection;
    NSLog(@"self.connect = %@",self.connect);
    self.completeBlock = handler;
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
#if 0
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    //分界线 --AaB03x
    NSString *startSymbol = [NSString stringWithFormat:@"--%@",SYMBOL];
    //结束符 AaB03x--
    NSString *endSymbol = [NSString stringWithFormat:@"--%@--",SYMBOL];
    if (dict)
    {
        NSString *dataKey = nil;
        NSMutableString *bodyString = [NSMutableString stringWithFormat:@""];
        for (NSString *key in [dict allKeys])
        {
            id obj = [dict valueForKey:key];
            if ([obj isKindOfClass:[NSData class]])
            {
                dataKey = key;
            }
            else
            {
                [bodyString appendFormat:@"%@\r\n",startSymbol];
                //添加字段名称，换2行
                [bodyString appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
                //添加字段的值
                [bodyString appendFormat:@"%@\r\n",[dict objectForKey:key]];
            }
        }
        
        //添加分界线，换行
        [bodyString appendFormat:@"%@\r\n",startSymbol];
        //声明pic字段，文件名为boris.png
        [bodyString appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.%@\"\r\n",dataKey,dataKey,_contentType];
        //声明上传文件的格式
        [bodyString appendFormat:@"Content-Type: %@\r\n\r\n",_contentType];
        //声明结束符：--AaB03x--
        NSString *end = [NSString stringWithFormat:@"\r\n%@",endSymbol];
        //声明myRequestData，用来放入http body
        NSMutableData *requestData = [NSMutableData data];
        //将body字符串转化为UTF8格式的二进制
        [requestData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        [requestData appendData:[dict objectForKey:dataKey]];
        //加入结束符--AaB03x--
        [requestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        //设置HTTPHeader中Content-Type的值
        NSString *content = [[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",SYMBOL];
        //设置HTTPHeader
        //[request setValue:content forHTTPHeaderField:@"Content-Type"];
        [request addValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [request addValue:[NSString stringWithFormat:@"%ld",(long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:requestData];
    }
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connect = connection;
    NSLog(@"self.connect = %@",self.connect);
    self.completeBlock = handler;
#if !(__has_feature(objc_arc))
    [connection release];
#endif
#endif
#if 0
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image=[dict objectForKey:@"pic"];
    //得到图片的data
    NSData* data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [dict allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"pic"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[dict objectForKey:key]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connect = conn;
    self.completeBlock = handler;
//    //设置接受response的data
//    if (conn) {
//        mResponseData = [[NSMutableData data] retain];
//    }
#endif
    
    //NSString *urlString = @"http://localhost/~apple/PHP/Study/Chapter/ch02/upload_file.php";
#if 0
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",@"bigImage.jpg"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"bigImage.jpg"], 1.0);
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
    self.connect = conn;
    self.completeBlock = handler;
#endif
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
    self.connect = conn;
    self.completeBlock = handler;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
    if (self.connect)
    {
        [self.connect cancel];
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
    if (self.completeBlock)
    {
        self.completeBlock(_downloadData,nil);
        self.completeBlock = nil;
    }
    
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.completeBlock)
    {
        self.completeBlock(_downloadData,error);
        self.completeBlock = nil;
    }
}

@end
