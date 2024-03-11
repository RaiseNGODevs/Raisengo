public class GeneralFunctions {
    public static String encryptValue(String valueToEncrypt){
        Blob targetBlob = Blob.valueOf('ViCodigo?2018');
        Blob key = Crypto.generateDigest('MD5', targetBlob);
        Blob data = Blob.valueOf(valueToEncrypt);
        Blob encrypted = Crypto.encryptWithManagedIV ('AES128', key, data);
        return EncodingUtil.convertToHex(encrypted);
    }
    
    public static Map<Object, List<SObject>> groupSObjectByField(List<SObject> objectList, String fieldName){
        Map<Object, List<SObject>> resultMap = new Map<Object, List<SObject>>();
        
        for( SObject obj : objectList ){
            Object fieldValue = obj.get(fieldName);
            if( fieldValue != null ){
                if( resultMap.containsKey(fieldValue))
                    resultMap.get(fieldValue).add(obj);
                else
                    resultMap.put(fieldValue, new List<SObject>{obj});
            }
        }
        
        return resultMap;
    }
    
    /*public static String decryptValue(String valueToDecrypt){
Blob targetBlob = Blob.valueOf('ViCodigo?2018');
Blob key = Crypto.generateDigest('MD5', targetBlob);
Blob data = EncodingUtil.convertFromHex(valueToDecrypt);
Blob decrypted = Crypto.decryptWithManagedIV ('AES128', key, data);
return decrypted.toString().subString(0,15);
}*/
}