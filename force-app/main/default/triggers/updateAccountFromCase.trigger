trigger updateAccountFromCase on Case (before insert ) {
    set<String> caseEmails = new set<String>();
    if( trigger.isBefore && trigger.isInsert ){
        if(!trigger.new.isEmpty()){
            for(Case c : trigger.new){
                if(c.SuppliedEmail != null && c.SuppliedEmail != ''){
                    caseEmails.add(c.SuppliedEmail.toLowerCase());
                }
            }
        }
    }

	//get All Contact emails
	Map<String, Contact> contactEmailMap = new Map<String,Contact>();
    For(Contact con : [Select Id, Email from Contact where Email IN:caseEmails]){
        contactEmailMap.put(con.Email.toLowerCase(), con);
    }
    
    //new Conatct
    List<Contact> newContacts =  new List<Contact>();
    //loop
    for(Case c : trigger.new){
        if(c.SuppliedEmail != Null && c.SuppliedEmail != ''){
            String normalEmails = c.SuppliedEmail.toLowerCase();
            if(contactEmailMap.ContainsKey(normalEmails)){
                c.ContactId = contactEmailMap.get(normalEmails).Id;
            }
            else {
                Contact newContact = new Contact();
                newContact.lastName =  c.Subject;
                newContact.Email = c.SuppliedEmail;
                newContact.Phone = c.SuppliedPhone;
                newContacts.add(newContact);
                c.ContactId = newContact.Id;
            }
        }
    }
    if(!newContacts.isEmpty()){
        Insert newContacts;
        
        for(integer i=0;i<trigger.new.size();i++){
            if(trigger.new[i].contactId == NULL){
                trigger.new[i].contactId = newContacts[i].Id;
            }
        }
    }
    
    
}




















   /* Set<Id> acctsToUpdate = new Set<Id>();
    if(trigger.isAfter && trigger.isInsert){
        if(!trigger.new.isEmpty()){
            system.debug('isEmpty:'+trigger.new.isEmpty());
            for(Case c : trigger.new){
                if(c.Status != null && c.Status.startsWithIgnoreCase('Closed')){
                    acctsToUpdate.add(c.AccountId);
                    system.debug('acctsToUpdate:'+acctsToUpdate);
                }
            }
        }
    }
 
    if(trigger.isAfter && trigger.isUpdate){
        if(!trigger.new.isEmpty()){
            system.debug('isEmptyUpdate:'+trigger.new.isEmpty());
            for(Case c : trigger.new){
                If(c.AccountId != trigger.oldMap.get(c.Id).AccountId){
                    acctsToUpdate.add(c.AccountId);
                    acctsToUpdate.add(trigger.oldMap.get(c.Id).AccountId);
                }
                else {
                    acctsToUpdate.add(c.AccountId);
                }
            }
            system.debug('newValues:'+trigger.newMap.Values());
            system.debug('oldValues:'+trigger.oldMap.Values());
            system.debug('acctsToUpdate:'+acctsToUpdate);
        }
    }
    

    List<Account> accountsToUpdate = new List<Account>();
    if(!acctsToUpdate.isEmpty()){
        for (AggregateResult aggr : [Select AccountId, Count(Id) closedCase 
                                     from Case where AccountId IN:acctsToUpdate 
                                     AND Status='Closed' Group By AccountId]){
                                         Id accountId = (Id) aggr.get('AccountId');
                                         Integer closedCase = (Integer) aggr.get('closedCase');
                                         
                                         Account accObj = new Account(Id = accountId);
                                         if(closedCase >=5){
                                             accObj.Rating = 'Hot';
                                         }
                                         else if(closedCase >=3){
                                             accObj.Rating = 'Warm';
                                         }
                                         else if(closedCase <=2){
                                             accObj.Rating = 'Cold';
                                         }
                                         accountsToUpdate.add(accObj);
                                         system.debug('accountsToUpdate:>'+accountsToUpdate);
                                     }
        
    }
    if(!accountsToUpdate.isEmpty()){
        Update accountsToUpdate;
    }*/