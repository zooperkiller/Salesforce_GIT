/*Suppose you are managing a team of sales reps in a company that sells software solutions to businesses. 
Your team uses Salesforce to manage customer contacts and associated accounts. 
You want to ensure that any changes made to a contact’s description field are automatically 
reflected in the associated account’s description field.Code  – */
trigger UpdateWithChild on Contact (after update) {
    Set<Id> parentAccountId = new Set<Id>();
    if(trigger.isAfter && trigger.isUpdate){
        if(!trigger.new.isEmpty()){
            for(Contact conObj : trigger.new){
                if(conObj.Description != trigger.OldMap.get(conObj.Id).Description){
                    parentAccountId.add(conObj.AccountId);
                    System.debug('parentAccountId=:'+parentAccountId);
                }
            }
        }
    }
    
    //check through maps 
    Map<Id,Account> accountToUpdate = new Map<Id,Account>();
    Map<Id,Account> mapOfIdandAccount = new Map<Id,Account>([Select Id, Description From Account Where Id IN:parentAccountId]);
    if(!trigger.new.isEmpty()){
        for(Contact con : trigger.new){
            Account acc = mapOfIdandAccount.get(con.AccountId);
            acc.Description = con.Description;
            accountToUpdate.put(acc.Id, acc);
        }
    }
    if(!accountToUpdate.isEmpty()){
        try{
            Update accountToUpdate.values();
        }
        catch (exception e){
            system.debug('Error:'+e.getMessage());
        }
    }
}