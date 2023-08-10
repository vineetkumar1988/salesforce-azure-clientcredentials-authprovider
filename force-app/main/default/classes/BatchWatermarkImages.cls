global class BatchWatermarkImages implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public String query = 'SELECT Id, Name FROM Account WHERE Id = \'0018d00000LBiwVAAT\'';
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> records) {         

        for(Account thisAccount : records){
            try {                  
                PageReference pageRef = Page.WatermarkDemo;
                pageRef.setRedirect(true);
                pageRef.getParameters().put('AccountId', thisAccount.Id);
                // system.debug('#### Content = '+EncodingUtil.base64Encode(ref.getContentAsPDF().toString()));
                //Blob blobContent = pageRef.getContentAsPDF(); 
                Blob blobContent = pageRef.getContent(); 
                
                ContentVersion cvObject = new ContentVersion();
                cvObject.Title = 'Watermark Demo';
                cvObject.PathOnClient = 'Watermark.png';
                cvObject.VersionData = blobContent;
                insert cvObject;
                
                if(cvObject.Id != null){
                    for(ContentVersion thisRecord : [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cvObject.Id LIMIT 1]){
                        cvObject = thisRecord;
                        break;
                    }
                    ContentDocumentLink cdlObject = new ContentDocumentLink();
                    cdlObject.ContentDocumentId = cvObject.ContentDocumentId;
                    cdlObject.LinkedEntityId = thisAccount.Id;
                    cdlObject.Visibility = 'AllUsers';
                    insert cdlObject;   
                }
            }catch (Exception e) {         
                System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );           
            }
        }
    }   
    global void finish(Database.BatchableContext BC){ }

}// End of class.