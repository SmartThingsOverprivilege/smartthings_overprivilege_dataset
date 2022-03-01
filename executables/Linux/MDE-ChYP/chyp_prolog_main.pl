/*:- [chyp_prolog_rules].
:- [chyp_prolog_facts].
*/

writeToFiles(Stream2, Data) :-%Stream1
    /*writeln(Stream1, Data),*/
    writeln(Stream2, Data).

main :-
/*open('appresult.txt', write, Stream1),*/
/*linux-specific*/
open('./chyp_all_results.txt', append, Stream2),

writeToFiles(Stream2, 'App name:'),%Stream1

Query1=(application(desc,App)),
forall(Query1, writeToFiles(Stream2, App)),%Stream1
writeToFiles(Stream2, ''),%Stream1

writeToFiles(Stream2, 'Overprivilege Case 1:'),%Stream1
writeToFiles(Stream2, ''),%Stream1
Query2=(setof([case1,AppName,RuleId,Id,Capability,Resource], overprivilegedCase1(case1,AppName,RuleId,Id,Capability,Resource), AllOverprivilegedCase1)),
forall(Query2, writeToFiles(Stream2, AllOverprivilegedCase1)),%Stream1
writeToFiles(Stream2, ''),%Stream1

writeToFiles(Stream2, 'Overprivilege Case 2:'),%Stream1
writeToFiles(Stream2, ''),%Stream1
Query3=(setof([case2,AppName,Capability], overprivilegedCase2(case2,AppName,Capability), AllOverprivilegedCase2)),
forall(Query3, writeToFiles(Stream2, AllOverprivilegedCase2)),%Stream1
writeToFiles(Stream2, ''),%Stream1

writeToFiles(Stream2, 'Overprivilege Case 3:'),%Stream1
writeToFiles(Stream2, ''),%Stream1
Query4=(setof([case3,AppName,RuleIdCode,TriggerIdCode,ConditionIdCode,ActionIdCode,Capability,AttributeCommand,Value], overprivilegedCase3(case3,AppName,RuleIdCode,TriggerIdCode,ConditionIdCode,ActionIdCode,Capability,AttributeCommand,Value), AllOverprivilegedCase3)),
forall(Query4, writeToFiles(Stream2, AllOverprivilegedCase3)),%Stream1

writeToFiles(Stream2, ''),%Stream1
writeToFiles(Stream2, ''),%Stream1

%close(Stream1),
close(Stream2),
halt.
