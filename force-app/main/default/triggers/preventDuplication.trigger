trigger preventDuplication on Contact (before insert, before update) {

    Map<string, Contact> emailMap =  new map<string, Contact>();
    Map<String, Contact> phoneMap =  new map<string, Contact>();
    //for insert operation
    if(trigger.isBefore && trigger.isInsert){
        if(!trigger.new.isEmpty()){
            for(contact conInsert : trigger.new){
                emailMap.put(conInsert.Email, conInsert);
                phoneMap.put(conInsert.Phone, conInsert);
            }
        }
    }
    
    //for update Operation 
    if(trigger.isBefore && trigger.isUpdate){
        if(!trigger.new.isEmpty()){
            for(Contact conUpdate : trigger.new){
                if(trigger.oldMap.get(conUpdate.Id).Email != conUpdate.Email){
                    emailMap.put(conUpdate.Email, conUpdate);
                }
                if(trigger.OldMap.get(conUpdate.Id).Phone != conUpdate.Phone){
                    phoneMap.put(conUpdate.Phone, conUpdate);
                }
            }
        }
    }
    
    //checking duplicate
    String errorMessage = '';
    List<Contact> existingRecords = [Select Id, Email, Phone From Contact 
                                     where Email IN:emailMap.keySet() OR Phone IN: PhoneMap.keySet()];
    
    if(!existingRecords.isEmpty()){
        for(Contact conObj : existingRecords){
            if(conObj.Email != null){
                if(EmailMap.get(conObj.Email) != null){
                    errorMessage = 'Email';
                }
            }
            
            if(conObj.Phone != Null ){
                if(PhoneMap.get(conObj.Phone) != Null){
                    errorMessage = errorMessage +(errorMessage != '' ?'and Phone' :'Phone');
                }
            }
        }
    }
    
    if(!trigger.new.isEmpty()){
        for(Contact objCon : trigger.new){
            if(errorMessage != ''){
                objCon.addError('Your Contact' +errorMessage+ 'already exists in system');  
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}