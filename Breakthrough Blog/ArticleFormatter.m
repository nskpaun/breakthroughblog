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
    
    NSString *cssString = @"<style type='text/css'>  blockquote {font-style:italic;} div { width: 280px; margin-left: 7px;font-family: Avenir; color:#000000; } h1 { font-family: Avenir; color:#567bce; float:center; } subheading { font-family: Avenir; color:#6a645e; } np { font-family: Avenir; } mydivider { color:#ffffff; witdth:90% height:5px;} .cta { -webkit-appearance: none; width:115%; border: 1px solid #6e6e6e; border-radius: 2px; padding: 5px; margin-left:2%; ; font-family: Avenir; color:#6a645e; font-size:16px;} div5 {margin-left: -18%; width: 95%;} </style>";
    
    NSString *metaString = @"<meta name = \"viewport\" content = \"width = 300, initial-scale = 1.0, user-scalable = yes\">";
    NSString *titleString = [NSString stringWithFormat:@"<h1>%@</h1>", post.title ];
    NSString *authorString = [NSString stringWithFormat:@"<subheading>BY %@</subheading>", [post.author uppercaseString] ];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateString = [NSString stringWithFormat:@"<subheading>%@</subheading>", [formatter stringFromDate:post.postDate]];

    
    NSString *contentString = [NSString stringWithFormat:@"%@ <strong>Notes:</strong> </br> <ul> [raw_html_snippet id=\"baccnote\"] </ul>", post.htmlContent ];
    

    
    NSString* htmlString = [NSString stringWithFormat:@"%@%@%@ <div> %@%@&nbsp&nbsp&nbsp&nbsp%@  </li><mydivider>___________________________________</mydivider> <np>%@</np> </br></br></br></br></br></br></br></br></br></br></br> </div>",metaString,javaScript,cssString,titleString,authorString,dateString,contentString ];
    
    
    return [ArticleFormatter insertTextAreas:htmlString withPost:post];
}

+(NSString*)insertTextAreas:(NSString*)htmlIn withPost:(Post*)post
{
    
    NSUInteger count = 0, length = [htmlIn length];
    NSRange range = NSMakeRange(0, length);
    NSString *replaceMe = @"[raw_html_snippet id=\"baccnote\"]";
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
            
            NSRange liRange = [[[htmlIn substringFromIndex:range.location] substringToIndex:replaceMe.length+7] rangeOfString:@"</li>"];
            NSRange ulRange = [[[htmlIn substringFromIndex:range.location] substringToIndex:replaceMe.length+7] rangeOfString:@"</ul>"];
            if (liRange.location == NSNotFound && ulRange.location == NSNotFound) {
                if (note) {
                    textAreaHtml = [NSString stringWithFormat:@"<ul><div5><textarea class=\"cta\" id=\"target%d\"  placeholder=\"Add your notes...\" rows=\"1\">%@</textarea></div5></ul>",count/2, note.text];
                    
                } else {
                    textAreaHtml = [NSString stringWithFormat:@"<ul><div5><textarea class=\"cta\" id=\"target%d\" placeholder=\"Add your notes...\" rows=\"1\"></textarea></div5></ul>",count/2];
                }
            } else {
            
                if (note) {
                     textAreaHtml = [NSString stringWithFormat:@"<div5><textarea class=\"cta\" id=\"target%d\"  placeholder=\"Add your notes...\" rows=\"1\">%@</textarea></div5>",count/2, note.text];
                    
                } else {
                   textAreaHtml = [NSString stringWithFormat:@"<div5><textarea class=\"cta\" id=\"target%d\" placeholder=\"Add your notes...\" rows=\"1\"></textarea></div5>",count/2];
                }
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
