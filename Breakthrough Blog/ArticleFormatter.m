//
//  ArticleFormatter.m
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/13/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import "ArticleFormatter.h"
#import "Note.h"

@implementation ArticleFormatter

+(NSString*)formatPostToHtml:(Post*)post
{
    NSString *javaScript = @"<script src=\"jquery-1.8.1.min.js\"></script> <script src=\"jquery.autogrowtextarea.min.js\"> </script>";
    
    NSString *cssString = @"<style type='text/css'>h1 { font-family: Avenir; color:#567bce; } subheading { font-family: Avenir; color:#6a645e; } p { padding: 10px; font-family: Avenir; } mydivider { color:#ffffff; witdth:90% height:5px;} .cta { -webkit-appearance: none; width:95%; border-radius: 0px; padding: 5px; margin-left:2%; border-color: #ffffff; font-family: Avenir; color:#6a645e; font-size:16px;} </style>";
    
    NSString *metaString = @"<meta name = \"viewport\" content = \"width = 300, initial-scale = 1.0, user-scalable = yes\">";
    NSString *titleString = [NSString stringWithFormat:@"<h1>%@</h1>", post.title ];
    NSString *authorString = [NSString stringWithFormat:@"<subheading>BY %@</subheading>", [post.author uppercaseString] ];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateString = [NSString stringWithFormat:@"<subheading>%@</subheading>", [formatter stringFromDate:post.postDate]];

    
    NSString *contentString = post.htmlContent;
    

    
    NSString* htmlString = [NSString stringWithFormat:@"%@%@%@ <div> %@%@&nbsp&nbsp&nbsp&nbsp%@ </br> </li><mydivider>___________________________________</mydivider> <p>%@</p> </br></br></br></br></br></br></br></br></br></br></br> </div>",metaString,javaScript,cssString,titleString,authorString,dateString,contentString ];
    
    
    return [ArticleFormatter insertTextAreas:htmlString withPost:post];
}

+(NSString*)insertTextAreas:(NSString*)htmlIn withPost:(Post*)post
{
    
    NSUInteger count = 0, length = [htmlIn length];
    NSRange range = NSMakeRange(0, length);
    
    NSString *mutableHtml = @"";
    NSString *jqueryString = @" <script> $(document).ready(function() { ";
    NSUInteger lastLocation = 0;
    while(range.location != NSNotFound)
    {
        range = [htmlIn rangeOfString: @"[raw_html_snippet id=\"baccnote\"]" options:0 range:range];
        if(range.location != NSNotFound)
        {
            jqueryString = [NSString stringWithFormat:@"%@ $(\"#target%d\").autoGrow(); ", jqueryString, count/2];
            NSString *lastLocationString = [[htmlIn substringFromIndex:lastLocation ] substringToIndex:(range.location - lastLocation)];
            mutableHtml = [NSString stringWithFormat:@"%@%@", mutableHtml,lastLocationString];
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            NSString *textAreaHtml;
            Note *note = [Note getNoteForPostId:post.pid andQuestion:[NSNumber numberWithInteger:count/2]];
            if (note) {
                 textAreaHtml = [NSString stringWithFormat:@"<textarea class=\"cta\" id=\"target%d\"  placeholder=\"Add your notes...\" rows=\"1\">%@</textarea>",count/2, note.text];
                
            } else {
               textAreaHtml = [NSString stringWithFormat:@"<textarea class=\"cta\" id=\"target%d\" placeholder=\"Add your notes...\" rows=\"1\"></textarea>",count/2];
            }
            count++;

            mutableHtml = [NSString stringWithFormat:@"%@%@", mutableHtml,textAreaHtml ];
            count++;
            lastLocation = range.location;
        }
        
        

    }
    NSString *lastLocationString = [htmlIn substringFromIndex:lastLocation];
    mutableHtml = [NSString stringWithFormat:@"%@%@%@});	</script>", mutableHtml,lastLocationString,jqueryString];
    
    
    return mutableHtml;
}



@end
