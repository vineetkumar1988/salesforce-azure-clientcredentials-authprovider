public with sharing class WSSecurityUtility {
    public class UsernameToken{
        public String Username;
        public String Password;
        public String Nonce;
        public String dt;
        public String Digest;
        public String Header;
        
        public UsernameToken(String username,String password){
            System.debug('WSSecurityUtil -Logger in med '+username+' - '+password);
            this.Username = username;
            this.Password = password;
            this.Nonce = generateNounce();
            this.dt = generateTimestamp();
            this.Digest = generateDigest(Nonce,dt,Password);
            this.Header = generateHeader(username,Digest,Nonce,dt);
            // this.Header = generateCustomHeader(Username, Password); 
        }
        
        /* Generate Nounce, random number base64 encoded */
        public String generateNounce(){    
            String nonce='';
            String possible = '0123456789abcdef';
            while (nonce.length() < 16) {
            Integer i = Math.mod(Math.abs(Crypto.getRandomInteger()), possible.length());
            nonce += possible.substring(i, i+1);
            }
            String nonce64 = EncodingUtil.convertToHex(Blob.valueOf(nonce));
            return nonce64;
        }

        /* Generate timestamp in GMT. In Emarsys example with Z, work only without Z */
        public String generateTimestamp(){
            Datetime dt = Datetime.now();
            return dt.format('yyyy-MM-dd\'T\'HH:mm:ss');
            //return Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            //return dt.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        }
    
        /* Generate Digest */
        public String generateDigest(String nonce,String dt, String key){
            Blob shaOne = crypto.generateDigest('SHA1', blob.valueOf(nonce+dt+key));
            String hexConv= encodingUtil.convertToHex(shaOne);
            return EncodingUtil.base64Encode(blob.valueOf(hexConv));
        }
    
        /* Generate Header */
        public String generateHeader(String Username,String Digest,String Nonce,String dt){
            //return 'X-WSSE: UsernameToken Username="'+Username+'",PasswordDigest="'+Digest+'",Nonce="'+Nonce+'",Created="'+dt+'"';  
            return 'X-WSSE: UsernameToken Username="'+Username+'",PasswordDigest="'+Digest+'",Nonce="'+Nonce+'",Created="'+dt+'"';  
        }  

        /* Generate Custom Header */
        public String generateCustomHeader(String Username, String Password){
            return 'X-WSSE: UsernameToken Username="'+Username+'",Password="'+Password+'"';  
        }  
    }
}