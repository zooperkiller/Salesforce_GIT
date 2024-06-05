trigger TriggerForAccount on Account ( before Update,after update, before delete) {
    List<Contact> contactsToUpdate = new List<Contact>(); 
    if(trigger.isBefore && trigger.isUpdate){
        if(!trigger.new.isEmpty()){
            for(Account acc : trigger.new){
                Contact c = new Contact();
                c.LastName = acc.Name + '' + Integer.valueof((Math.random() * 1000));
                c.Email = acc.Email__c;
                c.Phone = acc.Phone;
                c.AccountId = acc.Id;
                contactsToUpdate.add(c);
            }
            
            if(!contactsToUpdate.isEmpty()){
                insert contactsToUpdate;
            }
        }
    }
}
/*list<Id> contactsId = new List<Id>();
    Map<Id, string> MapOfAccountIdAndEmail = new Map<Id,String>();
    
    if(trigger.IsBefore && trigger.isUpdate){
        if(!trigger.new.isEmpty()){
            for(Account ac: trigger.new){
                System.debug('@@ac.PrimaryContact__c'+ac.PrimaryContact__c);
                System.debug('@@ac.PrimaryContact__c!=null'+ac.PrimaryContact__c != null);
                System.debug('@@ac.PrimaryContact__r.primary__c'+ac.PrimaryContact__r.Primary__c);
                if(ac.PrimaryContact__c != null  ){
                   
                         MapOfAccountIdAndEmail.put(ac.id,ac.PrimaryContact__r.Email );
                   
                   
                }
            }
            System.debug('@@MapOfAccountIdAndEmail'+MapOfAccountIdAndEmail);
            
            for(Account acc : trigger.new){
                if(MapOfAccountIdAndEmail.containsKey(acc.id) 
                   && acc.PrimaryEmail__c != MapOfAccountIdAndEmail.get(acc.Id)){
                       acc.PrimaryEmail__c = MapOfAccountIdAndEmail.get(acc.Id);
                   }
            }
            
        }
    }

*/


 /*   List<contact> listOfContact = new List<Contact>();
    if(trigger.IsAfter && trigger.isUpdate){
        for(Account ac : trigger.new){
            if(ac.Industry != trigger.oldMap.get(ac.Id).Industry){
                List<Contact> relatedContacts = [Select Id,AccountId from Contact Where AccountId =: ac.Id];
                
                
                for(Contact con : relatedContacts){
                    con.Account_Industry__c = ac.Industry;
                    listOfContact.add(con);
                }
            }
        }
        if(!listOfContact.isEmpty()){
           Update listOfContact;
        }
    }*/
/*Set<Id> setOfAccountId = new Set<Id>();
    
    if(trigger.isBefore && trigger.isDelete){
        if(!trigger.new.isEmpty()){
            for(Account a : trigger.New){
                if(a.Id != null){
                    setOfAccountId.add(a.Id);
                }
            }
            
            Map<id, Integer> MapOfContactCount = new Map<Id,Integer>();
            for(Account a: [Select Id, (Select Id From Contacts) From Account Where Id IN:setOfAccountId]){
                if(a.contacts.size()>0){
                    MapOfContactCount.put(a.Id, a.contacts.size());
                    
                }
            }
            For(Account acc: trigger.new){
                if(MapOfContactCount.containsKey(acc.Id) && MapOfContactCount.get(acc.Id)>0){
                    acc.AddError('Account Cannot be Deleted');
                }
            }
        }
    }*/