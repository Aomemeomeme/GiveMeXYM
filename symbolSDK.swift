//
//  symbolSDK.swift
//  SymbolTest01
//
//  Created by 岡田貴紀 on 2023/02/20.
//

import Foundation
import ed25519swift

enum NumOfSymbol:Int{
    
    enum NetworkType:Int{
        case mainnet = 104
        case testnet = 152
    }

    enum txType:Int{
        case transfer = 16724
    }
    
    case version = 1
    
}

// あとでprivateにする
class CommonMethod{
    
    
    func getXYMMount(address:String,nodeURL:String = "https://~~~:3001") async throws -> Double {
        
        // NACW73ZWAD6RGZPC3P64DN3KYK5XDLLMVGHW2KQ
        
        var resultFloat:Double = -1
        
        let url = URL(string: nodeURL + "/accounts/" + address)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        //print(data)
        //print(String(describing: type(of: data)))
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])as? [String: Any]
            
            let account = object!["account"] as! [String: Any]
            
            let mosaics = account["mosaics"] as? [Any]
            mosaics?.forEach{ mosaic in
                let m = mosaic as? [String:Any]
                let id = m!["id"] as? String
                
                if id == "6BED913FA20223F8" {
                    
                    let amount = (m!["amount"]! as? String)!
                    let i = Double(amount)!
                    resultFloat = Double(i / 1000000)
                    return
                }
                
            }
        } catch let error {
            print(error)
        }
        return resultFloat
        
    }
    
    private let base32Table = [
        "0":"A",
        "1":"B",
        "2":"C",
        "3":"D",
        "4":"E",
        "5":"F",
        "6":"G",
        "7":"H",
        "8":"I",
        "9":"J",
        "10":"K",
        "11":"L",
        "12":"M",
        "13":"N",
        "14":"O",
        "15":"P",
        "16":"Q",
        "17":"R",
        "18":"S",
        "19":"T",
        "20":"U",
        "21":"V",
        "22":"W",
        "23":"X",
        "24":"Y",
        "25":"Z",
        "26":"2",
        "27":"3",
        "28":"4",
        "29":"5",
        "30":"6",
        "31":"7"
    ]
    
    func utf8DecodeForPayload(val:String)->String{
        var resultStr:String = ""
        for code in val.utf8 {
            resultStr += String(code,radix: 16)
        }
        return "00" + resultStr
        //"00"は必須
    }
    
    private func getKey(val:String)->Int{
        let key = base32Table.first(where: { $1 == val })?.key
        return Int(key!)!
    }
    
    private func getKey2(val: String)->String{
        var resultStr:String = ""
        let val = val.uppercased()
        for s in val{
            var a = String(getKey(val: String(s)),radix: 2)
            while a.utf8.count < 5 {
                a = "0" + a
            }
            resultStr += a
        }
        return resultStr
    }
    
    private func base32Decode(val:String)->String{
        var resultStr:String = ""
        let val = getKey2(val: val)
        var tmpStr:String = ""
        for s in val {
            tmpStr += String(s)
            if tmpStr.utf8.count == 8 {
                let i:Int = Int(tmpStr,radix: 2)!
                let h :String = String(i,radix: 16)
                if h.utf8.count == 1 { resultStr += "0" }
                resultStr += h
                tmpStr = ""
            }
        }
        return resultStr
    }
    
    func base32DecodeByAddress(address:String)->String{
        let address = address + "A"
        return String(base32Decode(val: address).dropLast().dropLast())
    }
       
    // 秒でdead lineを設定 7200 = 7200秒 = 2h
    func getDeadLineBySecond(deadLine:Int,networkType:NumOfSymbol.NetworkType) -> Int{
        //let nowUnixTime:Int = Int(Date().timeIntervalSince1970)
        if networkType == NumOfSymbol.NetworkType.testnet {
            return (Int(Date().timeIntervalSince1970) - 1637848847 + deadLine) * 1000
        }else {
            return (Int(Date().timeIntervalSince1970) - 1615853185 + deadLine) * 1000
        }
        
    }
    
    // int -> payload
    // int -> arr + padding -> String
    
    // Int -> "00"
    func IntToPayload(num:Int,digit:Int) -> String{
        return UInt8ArrToString(
            arr:IntToUInt8Arr(num: num, digit: digit)
        )
    }
    
    // Int -> [UInt8]
    private func IntToUInt8Arr(num:Int , digit:Int) -> [UInt8] {
        
        var num = num
        var result:[UInt8]=[]
        
        while num != 0 {
            let m:Int = num % 256
            result.append(UInt8.init(m))
            num -= m
            num /= 256
        }
        
        return paddingUInt8Array(arr: result,digit: digit)
        
    }
    
    // [UInt8] -> "00"
    func UInt8ArrToString(arr:[UInt8]) -> String{
        
        var result:String = ""
        for i in arr {
            var tmpStr:String = String(i,radix: 16)
            if tmpStr.utf8.count == 1 { tmpStr = "0" + tmpStr }
            result += tmpStr
        }
        return result
    }
    
    // padding
    func paddingUInt8Array(arr:[UInt8]?,digit:Int) -> [UInt8] {
        
        var result:[UInt8]
            
        if arr != nil {
            result = arr!
        }else {
            result = []
        }
        
        while result.count < digit {
            result.append(0)
        }
        
        return result
        
    }
    
    // string -> [UInt8]
    func StringToArr(val:String) -> [UInt8] {
        
        var resultArr:[UInt8] = []
        var tmpStr:String = ""
        for s in val {
            //print("s:" + String(s))
            tmpStr += String(s)
            if tmpStr.utf8.count == 2 {
                let i:Int = Int(tmpStr,radix: 16)!
                resultArr.append(UInt8.init(i))
                tmpStr = ""
            }
        }
        
        return resultArr
        
    }
    
}

class TransferTransactionBody:CommonMethod{
    
    var recipientAddress:String
    //private var messageSize:Int
    private var mosaicCount:Int
    let mosaiID:String    // mosais : 不完全
    let amount:Int
    var message:String
    
    init(recipientAddress:String,
         message:String,
         mosaicID:String="3A8416DB2D53B6C8",
         amount:Int=1){
        
        self.recipientAddress = recipientAddress
        self.message = message
        self.mosaicCount = 1
        //self.messageSize = 14
        self.mosaiID = mosaicID
        self.amount = amount
        
    }
        
    func getPayload() -> String {
        
        var resultStr:String = ""
        
        resultStr += base32DecodeByAddress(address: self.recipientAddress)
        
        resultStr += IntToPayload(num: utf8DecodeForPayload(val:self.message).utf8.count / 2, digit: 2)
        
        resultStr += IntToPayload(num: self.mosaicCount, digit: 1)
        
        resultStr += IntToPayload(num: 0, digit: 1)
        
        resultStr += IntToPayload(num: 0, digit: 4)
        
        resultStr += self.mosaiID
        
        resultStr += IntToPayload(num: self.amount, digit: 8)
        
        resultStr += utf8DecodeForPayload(val:self.message)
        
        return resultStr
        
    }
    
}

class TransferTransaction:CommonMethod{
    
    let signerPrivateKey:String
    let version:NumOfSymbol
    let networkType:NumOfSymbol.NetworkType
    let txType:NumOfSymbol.txType
    let fee:Int
    let deadLine:Int
    
    let transferTransactionBody:TransferTransactionBody
    
    init(
        signerPrivateKey:String,
        networkType:NumOfSymbol.NetworkType,
        fee:Int,
        deadLine:Int,
        recipientAddress:String,
        message:String,
        mosaicID:String,
        amount:Int
    ){
        
        self.signerPrivateKey = signerPrivateKey
        self.version = NumOfSymbol.version
        self.networkType = networkType
        self.txType = NumOfSymbol.txType.transfer
        self.fee = fee
        self.deadLine = deadLine
        
        self.transferTransactionBody = TransferTransactionBody(recipientAddress: recipientAddress,
                                                               message: message,
                                                               mosaicID: mosaicID,
                                                               amount: amount)
        
    }
    
    func getPayload() -> String{
        
        var variableData:String = ""
        var resultStr:String = ""
        
        variableData = IntToPayload(num: self.version.rawValue, digit: 1)
        
        variableData += IntToPayload(num: self.networkType.rawValue, digit: 1)
        
        variableData += IntToPayload(num: self.txType.rawValue, digit: 2)
        
        variableData += IntToPayload(num: self.fee, digit: 8)
        
        variableData += IntToPayload(num: getDeadLineBySecond(deadLine: self.deadLine, networkType: self.networkType), digit: 8)
        
        variableData += self.transferTransactionBody.getPayload()
        
        resultStr = IntToPayload(num: 0, digit: 4) + resultStr
        
        let pubKey = UInt8ArrToString(arr: Ed25519.calcPublicKey(secretKey: StringToArr(val: self.signerPrivateKey)))
        
        resultStr = pubKey + resultStr
        
        if self.networkType == NumOfSymbol.NetworkType.testnet {
            variableData = "7fccd304802016bebbcd342a332f91ff1f3bb5e902988b352697be245f48e836" + variableData // testnet
        }else{
            variableData = "57F7DA205008026C776CB6AED843393F04CD458E0AA2D9F1D5F31A402072B2D6" + variableData // testnet
        }
        
        let signature:[UInt8] = Ed25519.sign(
            message: StringToArr(val: variableData),
            secretKey: StringToArr(val: self.signerPrivateKey))
        resultStr = UInt8ArrToString(arr: signature) + resultStr
        
        resultStr = IntToPayload(num: (resultStr.utf8.count / 2) + 8, digit: 8)  + resultStr
        
        return resultStr
        
    }
    
    func sendPayload(nodeURL:String = "https://~~~:3001") async throws -> String?{
        
        let payload:String = self.getPayload().uppercased()
                         
        let data: [String: Any] = ["payload": payload]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: data, options: []) else { return nil }
        
        //let url = URL(string: "https://001-sai-dual.symboltest.net:3001/transactions")!
        let url = URL(string: nodeURL + "/transactions")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"      // Postリクエストを送る(このコードがないとGetリクエストになる)
        request.httpBody = httpBody
        
        let (responce, _) = try await URLSession.shared.data(for: request)
        
        return String(data:responce,encoding: .utf8)!
        
        
    }
    
}
