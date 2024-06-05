trigger OpportunityTrigger on Opportunity (  after Update) { 
    Set<Id> setOfAccountId = new Set<Id>();
    Map<Id, Decimal> MapOfIdandInteger = new Map<Id,Decimal>();
    if(trigger.isAfter && trigger.isUpdate){
        if(!trigger.new.isEmpty()){
            for(Opportunity op : trigger.new){
                setOfAccountId.add(op.AccountId);
            }
            
            List<AggregateResult> aggr = [Select AccountId, SUM(Amount) totalSum From Opportunity
                                          Where AccountId =:setOfAccountId Group BY AccountId];
            System.Debug('@@aggr'+aggr);
             
            for(AggregateResult ag : aggr){
                MapOfIdandInteger.put((Id)ag.get('AccountId'), (Decimal)ag.get('totalSum'));
                
            }
            System.Debug('@@MapOfIdandInteger'+MapOfIdandInteger);
            list<Account> accountsToUpdate = new List<Account>();
            for(Id AccountIds : MapOfIdandInteger.keySet()){
                Account accUpdate = new Account();
                accUpdate.Id = AccountIds;
                accUpdate.TotalSpecialDealAmount__c = MapOfIdandInteger.get(AccountIds);
                accountsToUpdate.add(accUpdate);
            }
            
            
            if(!accountsToUpdate.isEmpty()){
                Update accountsToUpdate;
            }
            //TotalSpecialDealAmount__c
                
                
        }
    }
}
/*Set<Id> setOfAccountId = new Set<Id>();
    
    if(trigger.isAfter && trigger.isUpdate){
        if(!trigger.new.isEmpty()){
            for(Opportunity op : trigger.new){
                setOfAccountId.add(op.AccountId);
            }
            System.debug('@@setOfAccountId'+setOfAccountId);
            
            List<AggregateResult> aggrResult = [Select AccountId, Count(Id) oppIds 
                                                from Opportunity Where AccountId IN:setOfAccountId 
                                                Group By AccountId];
            System.debug('@@aggrResult'+aggrResult);
            
            Map<Id, Integer> MapOfCountOfOppor = New Map<Id, Integer>();
            
            for(AggregateResult agg : aggrResult){
                MapOfCountOfOppor.put((Id)agg.get('AccountId'),(Integer)agg.get('oppIds') );
            }
            System.debug('@@MapOfCountOfOppor'+MapOfCountOfOppor);
            
            
            List<Account> AccountsToUpdate = new List<Account>();
            For(Id AccountIds :MapOfCountOfOppor.keySet()){
               Account accToUpdate = new Account();
                accToUpdate.Id =  AccountIds;
                accToUpdate.Number_Of_contacts__c = MapOfCountOfOppor.get(AccountIds);
                AccountsToUpdate.add(accToUpdate);
            }
            
            if(!AccountsToUpdate.isEmpty()){
                Update AccountsToUpdate;
            }  
        }
    }*/


/*Set<Id> setOfAccountIds = new Set<Id>();
if(trigger.isBefore && trigger.IsInsert){
if(!trigger.new.IsEmpty()){
for(Opportunity op : trigger.new){
if(op.AccountId != null && op.StageName == 'Closed Won'){
setOfAccountIds.add(op.AccountId); 
}
}

//Query the accounts to check the condition 
Map<Id, Account> MapOfIdandAccount = new Map<Id,Account>();

for(Account acc : [Select Id, Active__c, Ownership From Account Where Id IN:setOfAccountIds AND Active__c = 'No' AND Ownership ='Private' ]){
MapOfIdandAccount.put(acc.Id, acc);

}

for(Opportunity op : trigger.new){
if(MapOfIdandAccount.containsKey(op.AccountId) && op.StageName == 'Closed Won'){
op.AddError('𝐎𝐩𝐩𝐨𝐫𝐭𝐮𝐧𝐢𝐭𝐲 𝐜𝐚𝐧𝐧𝐨𝐭 𝐛𝐞 𝐮𝐩𝐝𝐚𝐭𝐞𝐝 𝐭𝐨 𝐂𝐥𝐨𝐬𝐞𝐝 𝐖𝐨𝐧 𝐟𝐨𝐫 𝐈𝐧𝐚𝐜𝐭𝐢𝐯𝐞 𝐀𝐜𝐜𝐨𝐮𝐧𝐭" 𝐟𝐨𝐫 𝐛𝐨𝐭𝐡 𝐢𝐧𝐬𝐞𝐫𝐭𝐢𝐨𝐧 𝐚𝐧𝐝 𝐮𝐩𝐝𝐚𝐭𝐢𝐨𝐧');
}
}
}
}
*/
/* Map<Id, Opportunity> MapOfStringAndOpportunity = new Map<Id,Opportunity>();
if(trigger.isInsert && trigger.isAfter){
if(!trigger.new.isEmpty()){
for(Opportunity opp : trigger.new){
if(opp.AccountId != null && opp.OpportunityZone__c !=null){

MapOfStringAndOpportunity.put(opp.AccountId, opp);
}
}
system.debug('@@MapOfStringAndOpportunity'+MapOfStringAndOpportunity); 
List<Account> updateAccounts = new List<Account> ();

For(Account a : [Select Id,AccountZone__c from Account where Id IN:MapOfStringAndOpportunity.keySet()]){
if(MapOfStringAndOpportunity.containsKey(a.Id)){
a.AccountZone__c = MapOfStringAndOpportunity.get(a.Id).OpportunityZone__c;
updateAccounts.add(a);
}
}
if(!updateAccounts.isEmpty()){
update updateAccounts;
}

}
}
*/






/* Set<Id> accIds = new Set<Id>();
if(trigger.isAfter && (trigger.isInsert || trigger.isUndelete)){
if(!trigger.new.isEmpty()){
for(Opportunity oppObj : trigger.new){
if(oppObj.AccountId != Null){
accIds.add(oppObj.AccountId); //accountIds of OPP has been added to the Set<>
system.debug('@@accIds'+accIds);
}
}
}
System.debug('Opportunities inserted/undeleted: ' + Trigger.new.size());
}
//isUpdate
if(trigger.isAfter && trigger.isUpdate){
if(!trigger.new.isEmpty()){
for(Opportunity oppObj : trigger.new){
if(oppObj.AccountId != trigger.oldMap.get(oppObj.Id).AccountId){
//account Id is added to set, if account Id is changed of the Opp record.
accIds.add(oppObj.AccountId);
accIds.add(trigger.oldMap.get(oppObj.Id).AccountId);
System.debug('Old AccountIds: ' + Trigger.oldMap.values());
System.debug('New AccountIds: ' + Trigger.newMap.values());
system.debug('@@setOfAccount'+accIds);
}
else{
//account Id is added to set, if other field , other than Acc Id is changed.
accIds.add(oppObj.AccountId);
System.debug('New AccountIds: ' + Trigger.newMap.values());
system.debug('@@accIdselse'+oppObj);
system.debug('@@setOfAccount'+accIds);

}
}
}
System.debug('Opportunities updated: ' + Trigger.new.size());
}
//isDelete
if(trigger.isAfter && trigger.isDelete){
if(!trigger.old.isEmpty()){
for(Opportunity oppObj : trigger.old){
if(oppObj.AccountId != null){
accIds.add(oppObj.AccountId);
}
}
}
system.debug('@@setOfAccount'+accIds);
System.debug('Opportunities deleted: ' + Trigger.old.size());
}

//check amounts\
Map<Id, Account> accMap = new Map<Id,Account>();

if(!accIds.isEmpty()){
List<AggregateResult> aggrList = [Select AccountId, SUM(Amount) totalAm 
from Opportunity 
where AccountId IN:accIds 
GROUP BY AccountId];
if(!aggrList.isEmpty()){

for(AggregateResult aggr : aggrList){
Id AccId = (Id)aggr.get('AccountId');
Decimal totalAmt = (Decimal)aggr.get('totalAm');

Account acc = new Account(Id = AccId);
acc.Sum_Of_Opportunity__c = totalAmt;
accMap.put(AccId, acc); // put the accId and Acc to update
}
}
else {
//handle accouts with no Opp
for (Id accNoId : accIds){
Account acc = new Account(Id = accNoId);
acc.Sum_Of_Opportunity__c = 0;
accMap.put(accNoId, acc);
}
}
if(!accMap.isEmpty()){
Update accMap.values();
}
}
*/