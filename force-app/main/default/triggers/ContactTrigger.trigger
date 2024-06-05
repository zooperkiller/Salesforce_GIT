trigger ContactTrigger on Contact (after update) {
    Map<Id, string> MapofAccountIdAndEmail = new Map<Id, String>();
    Set<Id> SetOfAccountId = new Set<Id>();
    if(trigger.isAfter && trigger.IsUpdate){
        if(!trigger.new.isEmpty()){
            for(Contact con : trigger.new){
                if(con.Email != trigger.oldMap.get(con.Id).Email){
                    SetOfAccountId.add(con.AccountId); 
                    MapofAccountIdAndEmail.put(con.AccountId, con.Email);
                }
            }
            System.debug('@@SetOfAccountId'+SetOfAccountId);
            System.debug('@@MapofAccountIdAndEmail'+MapofAccountIdAndEmail);
            
            List<Account> accountToUpdate = new List<Account>();
            for(Id AccountId :MapofAccountIdAndEmail.KeySet() ){
                Account newAccount = new Account();
                newAccount.Id = AccountId;
                newAccount.PrimaryEmail__c = MapofAccountIdAndEmail.get(AccountId);
                accountToUpdate.add(newAccount);
            }
            
            if(!accountToUpdate.isEmpty()){
                Update accountToUpdate;
            }
        }
    }
}


/*Set<Id> setOfAccountId = new Set<Id>();
    
    if(trigger.isAfter && trigger.IsUpdate){
        if(!trigger.new.isEmpty()){
            
            for(Contact con : trigger.new){
                setOfAccountId.add(con.AccountId);
            }
            system.debug('@@setOfAccountId'+setOfAccountId);
            
            List<AggregateResult> aggrResult = [Select AccountId, count(Id) ids 
                                                from Contact where AccountId In:SetOfAccountId 
                                                Group BY AccountId];
            
            system.debug('@@aggrResult'+aggrResult);
            
            Map<id, Integer> MapofNumberOfContact = new Map<id,Integer>();
            for(AggregateResult agg : aggrResult){
                MapofNumberOfContact.put((Id)agg.get('AccountId'),(integer)agg.get('ids'));
            }
            system.debug('@@MapofNumberOfContact'+MapofNumberOfContact);
            
            list<Account> accountsToUpdate = new List<Account>();
            
            for(Id accountId : MapofNumberOfContact.keySet()){
                Account accToUpdate  = new Account();
                accToUpdate.Id = accountId;
                accToUpdate.Number_Of_contacts__c = MapofNumberOfContact.get(accountId);
                accountsToUpdate.add(accToUpdate);
                
            }
            
            if(!accountsToUpdate.isEmpty()){
                Update accountsToUpdate;
            }
        }
    }*/
//Number_Of_contacts__c
/*Map<Id, String> MapOfIdandString = new Map<Id,String>();
if(trigger.isAfter && trigger.isUpdate){
if(!trigger.new.isEmpty()){
for(Contact con : trigger.new){
if(con.Phone != trigger.oldMap.get(con.Id).Phone){
MapOfIdandString.put(con.AccountId,con.Phone);
}
}
List<Account> accountsUpdate = new List<Account>();

for(Id accountId : MapOfIdandString.keySet()){
Account acc = new Account();
acc.id = accountId;
acc.PrimaryContactPhone__c = MapOfIdandString.get(accountId);
accountsUpdate.add(acc);
}

Update accountsUpdate;
}
}*/