//
//  savePrivateKey.swift
//  SymbolTest01
//
//  Created by 岡田貴紀 on 2023/02/23.
//

import SwiftUI

struct savePrivateKey: View {
    
    @Binding private var presented: Bool
    
    @State var privateKey:String = ""
    @State var isAlert:Bool = false
    @State var alertText:String = ""
    
    init(presented:Binding<Bool>, privateKey: String) {
        self._presented = presented
        self.privateKey = privateKey
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            Text("秘密鍵を入力してください")
            SecureField("秘密鍵を入力してください。", text: $privateKey)
            Button("保存") {
                if privateKey != "" {
                    
                    let kc:KeyChain = KeyChain()
                    if kc.saveKeyChain(tag: "tag", value: privateKey) {
                        self.alertText = "成功だぜ"
                        self.isAlert = true
                        print("成功だぜ")
                    }else{
                        self.alertText = "失敗だぜ"
                        self.isAlert = true
                        print("失敗だぜ")
                    }
                    
                }else{
                    self.alertText = "文字がないぜ"
                    self.isAlert = true
                    print("文字がないぜ")
                }
                
            }.alert(isPresented: $isAlert) {
                Alert(title: Text(self.alertText),
                      //message: Text("右下の歯車のマークより保存してください"),
                      dismissButton: .default(Text("OK")))
            }
            
            Spacer()
            
            Button("消去") {
                
                
                //let kc:KeyChain = KeyChain()
                if KeyChain().deleteKeyChain(tag: "tag") {
                    self.alertText = "削除成功"
                    self.isAlert = true
                    print("success")
                } else {self.alertText = "削除失敗"
                    self.isAlert = true
                    print("falure")
                }
                
                
                
            }
            .alert(isPresented: $isAlert) {
                Alert(title: Text(self.alertText),
                      //message: Text("右下の歯車のマークより保存してください"),
                      dismissButton: .default(Text("OK")))
            }
            
            
            Spacer()
            
            Button("閉じる"){
                presented.toggle()
            }
            
            Spacer()
            
        }
        
    }
}

/*
struct savePrivateKey_Previews: PreviewProvider {
    static var previews: some View {
        savePrivateKey(presented: true, privateKey: "")
    }
}
*/

class KeyChain {
    
    func saveKeyChain(tag:String, value:String) -> Bool{
            
        guard let data = value.data(using: .utf8) else {
            return false
        }
        print(data)
        
        let saveQurry:[String:Any] = [
            kSecClass               as String : kSecClassKey,
            kSecAttrApplicationTag  as String : "tag",
            kSecValueData           as String : data
        ]
        
        let searchQuery:[String:Any] = [
            kSecClass               as String : kSecClassKey,
            kSecAttrApplicationTag  as String : "tag",
            kSecReturnAttributes    as String : true
        ]
        
        // 検索実行
        let matchingstatus = SecItemCopyMatching( searchQuery as CFDictionary, nil)
        
        //
        var itemAddStatus : OSStatus
        if matchingstatus == errSecItemNotFound {
            // save
            itemAddStatus = SecItemAdd(saveQurry as CFDictionary, nil)
        } else if matchingstatus == errSecSuccess {
            // 更新(削除してから新規登録)
            
            //delete
            if SecItemDelete(saveQurry as CFDictionary) == errSecSuccess{
                print("削除成功")
            }else{
                print("削除失敗")
            }
            
            //deleteKeyChain()
            
            // save
            itemAddStatus = SecItemAdd(saveQurry as CFDictionary, nil)
        }else{
            return false
        }
        
        // check status
        if itemAddStatus == errSecSuccess{
            print("正常終了")
        } else {
            return false
        }
        
        return true
        
    }
    
    func deleteKeyChain(tag:String) -> Bool{
        
        let saveQurry:[String:Any] = [
            kSecClass               as String : kSecClassKey,
            kSecAttrApplicationTag  as String : "tag",
            //kSecValueData           as String : ""
        ]
        
        let searchQuery:[String:Any] = [
            kSecClass               as String : kSecClassKey,
            kSecAttrApplicationTag  as String : "tag",
            kSecReturnAttributes    as String : true
        ]
        
        // 検索実行
        let matchingstatus = SecItemCopyMatching( searchQuery as CFDictionary, nil)
        
        if matchingstatus == errSecItemNotFound {
            return false
        } else if matchingstatus == errSecSuccess {
            //delete
            if SecItemDelete(saveQurry as CFDictionary) == errSecSuccess{
                return true
            }else{
                return false
            }
            
        }else{
            return false
        }
        
    }
    
    func getKeyChain(key:String) -> String?{
        
        let searchQuery:[String:Any] = [
            kSecClass               as String : kSecClassKey,
            kSecAttrApplicationTag  as String : key,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecReturnAttributes    as String : true
        ]
        
        
        // 2
        var item: AnyObject?
        let status = SecItemCopyMatching(searchQuery as CFDictionary, &item)
        guard status == errSecSuccess else {
            return nil
            //fatalError("Cannot find saved key in Keychain")
        }
        //print(item)
        let d = item as? NSDictionary
        
        // 3
        guard let keyData = d!["v_Data"]! as? Data else {
            fatalError("Key was found, but can't be convert to expected object ")
        }
        let value = String(data: keyData, encoding: .utf8)!
        return value
        
    }
    
}
