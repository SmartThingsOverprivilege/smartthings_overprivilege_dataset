include "SmartThings_Description.grm"
include "SmartThings_Groovy.grm"
include "SmartThings_Header.grm"
%include "SmartThings_Analyse.grm"
include "SmartThings_Message.grm"
%include "general_functions.txl"
%include "redefinitions.txl"

define descriptionId
    [srclinenumber?] 'description
end define

redefine map_entry
    [n*] [descriptionId] ': [n*] '" [description] '"
|    ...
end redefine

redefine program
    ...
|   [repeat description]
end redefine

% todo: extract other comments and free-form text
% Extract description from SmartThings app and save in a file in XML format
% full command:
% txl desc-to-xml.txl turn-it-on-when-im-here.groovy -newline -case -xml
% output file option: -o description.xml
% ex: txl desc-to-xml.txl zigbeeBigTurnOff.groovy -newline -case -xml - -filename zigbeeBigTurnOff_groovy
function main
    replace $ [program]
        program [program]
    % handle command line options
    import TXLargs [repeat stringlit]
    % filename: the desired output name for the SmartApp
    % this dashFilenameStr is specifically constructed because [stringlit] is broken in this groovy grammar
    construct dashFilenameStr [stringlit]
        _ [+ '-] [+ 'filename]
    deconstruct * TXLargs
        dashFilenameStr filename [stringlit]
    construct spaceChar [oneSpace]
        _
    construct OutputFileName [stringlit]
        filename [+ '_description] [+ '.] [+ 'xml]
    %( only passing filename in txl program because -case passed here makes issues
     with parsing the description with the first grammar first. ex: Turn will be
     parsed "Capitalized identifier" instead of Switch)%
    construct args [stringlit]
        _ [+ '-] [+ 'o] [quote spaceChar] [+ OutputFileName]
    %
    %construct allText [repeat double_quote_string]
    %    _ [^ program]
    construct desc [repeat description]
        _ [^ program]
    %construct allDesc [repeat description]
    %    desc [reparseText each allText]
    by
        %text [pragma args]
        %program
        desc [pragma args]%allDesc
end function

% take all the descriptions and join their repeat_permission_rule together

%(function reparseText text [double_quote_string]
    replace [repeat description]
        desc [repeat description]
    construct textFiltered [double_quote_string]
        text [removeLineNumbers] %[excludeNonDesc]
    construct textAsRepeat [repeat double_quote_string]
        textFiltered
    construct textToReparse [repeat desc_or_double_quote_string]
        _ [reparse textAsRepeat]
    deconstruct * [description] textToReparse
        newDesc [description]
    construct newDescAsRepeat [repeat description]
        newDesc
    by
        desc [. newDescAsRepeat]
end function)%

%(rule excludeNonDesc
    replace $ [double_quote_string]
        text [double_quote_string]
    where not
        text [textIsDesc]
    by
        ""
end rule
)%