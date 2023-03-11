//
//  ContentView.swift
//  SymbolTest01
//
//  Created by 岡田貴紀 on 2023/01/20.
//

import SwiftUI
import ed25519swift

struct ContentView: View {
    
    //@State var testOutput = "testOutput"
    
    @State var showModal : Bool = false
    @State var XYMAmount_ME : Double = 0
    @State var XYMAmount_TARGET : Double = 0
    
    @State var isAlert : Bool = false
    @State var isSend : Bool = false
    
    @State private var animate = false
    @State private var scale: CGFloat = 0.9
    
    @State var timer :Timer?
    //@State var count = 0
    
    var body: some View {
        
        NavigationView{
            
            VStack {
                Text("オラにXYMを分けてくれ")
                    .bold()
                    .font(.title)
                
                
                Spacer()
                
                VStack{
                    
                    /*
                    ForEach(1..<9){ i in
                        Text("\(i)")
                    }
                    */
                     
                    ZStack{
                        
                        //5 300
                        //if XYMAmount_TARGET > 300 {
                            Circle()
                            .fill(Color.mint)
                                .frame(width:
                                        XYMAmount_TARGET > 400 ?                                        CGFloat(UIScreen.main.bounds.width)
                                       :  CGFloat(UIScreen.main.bounds.width) * (( XYMAmount_TARGET  ) / 400 )
                                )
                                .opacity(0.5)
                        //}
                        
                        //6 400
                        if XYMAmount_TARGET > 400 {
                            Circle()
                                .fill(Color.green)
                                .frame(width:
                                        XYMAmount_TARGET > 500 ?                                        CGFloat(UIScreen.main.bounds.width - 40)
                                       :  CGFloat(UIScreen.main.bounds.width - 40) * (( XYMAmount_TARGET - 400 ) / 100 )
                                )
                                //.opacity(0.5)
                            
                                .scaleEffect(scale)
                                .animation(Animation.easeInOut(duration: 1).repeatForever().delay(0)) // 2.
                                .onAppear{
                                    withAnimation{
                                        
                                        self.scale = 1
                                    }
                                }
                        }
                        
                        //7 500
                        if XYMAmount_TARGET > 500 {
                            Circle()
                                .fill(Color.yellow)
                                .frame(width:
                                        XYMAmount_TARGET > 750 ?                                        CGFloat(UIScreen.main.bounds.width - 40)
                                       :  CGFloat(UIScreen.main.bounds.width - 40) * (( XYMAmount_TARGET - 500 ) / 250 )
                                )
                                //.opacity(animate ? 1.0 : 0)
                                .scaleEffect(scale)
                                .animation(Animation.easeInOut(duration: 9).repeatForever().delay(1)) // 2.
                                .onAppear{
                                    withAnimation{
                                        self.scale = 1
                                    }
                                }
                        }
                        
                        
                        //8 750
                        if XYMAmount_TARGET > 750 {
                            Circle()
                                .fill(Color.orange)
                                .frame(width:
                                        XYMAmount_TARGET > 1000 ?                                        CGFloat(UIScreen.main.bounds.width - 60)
                                       :  CGFloat(UIScreen.main.bounds.width - 60) * (( XYMAmount_TARGET - 750 ) / 250 )
                                )
                                //.opacity(animate ? 1.0 : 0)
                                .scaleEffect(scale)
                                .animation(Animation.easeInOut(duration: 1).repeatForever().delay(0)) // 2.
                                .onAppear{
                                    withAnimation{
                                        self.scale = 1
                                    }
                                }
                        }
                        
                        //9 1000
                        if XYMAmount_TARGET > 1000 {
                            Circle()
                                .fill(Color.purple)
                                .frame(width:
                                        XYMAmount_TARGET > 2500 ?                                        CGFloat(UIScreen.main.bounds.width - 80)
                                       :  CGFloat(UIScreen.main.bounds.width - 80) * (( XYMAmount_TARGET - 1000 ) / 1500 )
                                )
                                //.opacity(animate ? 1.0 : 0)
                                .scaleEffect(scale)
                                .animation(Animation.easeInOut(duration: 9).repeatForever().delay(1)) // 2.
                                .onAppear{
                                    withAnimation{
                                        self.scale = 1
                                    }
                                }
                        }
                        
                        //10 2500
                        if XYMAmount_TARGET > 2500 {
                            Circle()
                                .fill(Color.pink)
                                .frame(width:
                                        XYMAmount_TARGET > 5000 ?                                        CGFloat(UIScreen.main.bounds.width - 100)
                                       :  CGFloat(UIScreen.main.bounds.width - 100) * (( XYMAmount_TARGET - 2500 ) / 2500 )
                                )
                                //.opacity(animate ? 1.0 : 0)
                                .scaleEffect(scale)
                                .animation(Animation.easeInOut(duration: 1).repeatForever().delay(0)) // 2.
                                .onAppear{
                                    withAnimation{
                                        self.scale = 1
                                    }
                                }
                        }
                        
                        //11 5000
                        if XYMAmount_TARGET > 5000 {
                            Circle()
                                .fill(Color.red)
                                .frame(width:
                                        XYMAmount_TARGET > 7500 ?                                        CGFloat(UIScreen.main.bounds.width - 120)
                                       :  CGFloat(UIScreen.main.bounds.width - 120) * (( XYMAmount_TARGET - 5000 ) / 2500 )
                                )
                                //.opacity(animate ? 1.0 : 0)
                                .scaleEffect(scale)
                                .animation(Animation.easeInOut(duration: 9).repeatForever().delay(1)) // 2.
                                .onAppear{
                                    withAnimation{
                                        self.scale = 1
                                    }
                                }
                        }
                        
                        
                        //12 7500
                        if XYMAmount_TARGET > 7500 {
                            Circle()
                                .fill(Color.cyan)
                                .frame(width:
                                        XYMAmount_TARGET > 10000 ?                                        CGFloat(UIScreen.main.bounds.width - 140)
                                       :  CGFloat(UIScreen.main.bounds.width - 140) * (( XYMAmount_TARGET - 7500 ) / 2500 )
                                )
                                //.opacity(animate ? 1.0 : 0)
                                .scaleEffect(scale)
                                .animation(Animation.easeInOut(duration: 1).repeatForever().delay(0)) // 2.
                                .onAppear{
                                    withAnimation{
                                        self.scale = 1
                                    }
                                }
                        }
                        
                        //13 10000
                        if XYMAmount_TARGET > 10000 {
                            Circle()
                                .fill(Color.blue)
                                .frame(width:
                                        XYMAmount_TARGET > 10000 ?                                        CGFloat(UIScreen.main.bounds.width - 160)
                                       :  CGFloat(UIScreen.main.bounds.width - 160) * (( XYMAmount_TARGET - 7500 ) / 2500 )
                                )
                                //.opacity(animate ? 1.0 : 0)
                                .scaleEffect(scale)
                                .animation(Animation.easeInOut(duration: 9).repeatForever().delay(1)) // 2.
                                .onAppear{
                                    withAnimation{
                                        self.scale = 1
                                    }
                                }
                        }
                       
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        Text("XYM玉\n\(XYMAmount_TARGET) XYM")
                            //.background(Color.blue)
                            .frame(width: CGFloat(UIScreen.main.bounds.width),
                                   height: 300)
                            .multilineTextAlignment(.center)
                            
                    }.frame(width: CGFloat(UIScreen.main.bounds.width),
                            height: CGFloat(UIScreen.main.bounds.height)/2 - 75 )
                    
                    
                    Image("banzai_schoolgirl2")
                        .resizable()
                        .scaledToFill()
                        //.offset(y:150)
                        .frame(width: 1,height: 200)
                        //.clipped()
                    
                }
                
                //Spacer()
                
                VStack{
                    
                    HStack{
                        
                        Button(action: {
                            
                            let kc:KeyChain = KeyChain()
                            guard let val = kc.getKeyChain(key: "tag") else {
                                self.isAlert = true
                                return
                            }
                            
                            let t:TransferTransaction = TransferTransaction(
                                signerPrivateKey: val,
                                networkType: NumOfSymbol.NetworkType.mainnet,
                                fee: 160000,
                                deadLine: 7200,
                                recipientAddress: "NACW73ZWAD6RGZPC3P64DN3KYK5XDLLMVGHW2KQ",
                                message: getOmikuji(),
                                mosaicID: "F82302A23F91ED6B",
                                amount: 1000000)
                                            
                            Task{
                                guard let response = try await t.sendPayload() else { return }
                                if response.contains("pushed") {
                                    self.isSend = true
                                }
                            }
                            
                        }) {
                            Text("1XYM")
                                .bold()
                                .padding()
                                .frame(width: 100, height: 50)
                                .foregroundColor(Color.white)
                                .background(Color.blue)
                                .cornerRadius(25)
                        }
                        .alert(isPresented: $isAlert) {
                            Alert(title: Text("秘密鍵がありません"),
                                  message: Text("右下の歯車のマークより保存してください"),
                                  dismissButton: .default(Text("ガッテン")))
                        }
                        .alert(isPresented: $isSend) {
                            Alert(title: Text("トランザクションを送信しました"),
                                  //message: Text("右下の歯車のマークより保存してください"),
                                  dismissButton: .default(Text("OK")))
                        }
                        
                        
                        Button(action: {
                            
                            let kc:KeyChain = KeyChain()
                            guard let val = kc.getKeyChain(key: "tag") else {
                                self.isAlert = true
                                return
                            }
                            
                            let t:TransferTransaction = TransferTransaction(
                                signerPrivateKey: val,
                                networkType: NumOfSymbol.NetworkType.mainnet,
                                fee: 160000,
                                deadLine: 7200,
                                recipientAddress: "NACW73ZWAD6RGZPC3P64DN3KYK5XDLLMVGHW2KQ",
                                message: getOmikuji(),
                                mosaicID: "F82302A23F91ED6B",
                                amount: 10000000)
                                            
                            Task{
                                guard let response = try await t.sendPayload() else { return }
                                if response.contains("pushed") {
                                    self.isSend = true
                                }
                            }
                            
                        }) {
                            Text("10XYM")
                                .bold()
                                .padding()
                                .frame(width: 100, height: 50)
                                .foregroundColor(Color.white)
                                .background(Color.blue)
                                .cornerRadius(25)
                        }
                        .alert(isPresented: $isAlert) {
                            Alert(title: Text("秘密鍵がありません"),
                                  message: Text("右下の歯車のマークより保存してください"),
                                  dismissButton: .default(Text("ガッテン")))
                        }
                        .alert(isPresented: $isSend) {
                            Alert(title: Text("トランザクションを送信しました"),
                                  //message: Text("右下の歯車のマークより保存してください"),
                                  dismissButton: .default(Text("OK")))
                        }
                        
                        Button(action: {
                            let kc:KeyChain = KeyChain()
                            guard let val = kc.getKeyChain(key: "tag") else {
                                self.isAlert = true
                                return
                            }
                            let t:TransferTransaction = TransferTransaction(
                                signerPrivateKey: val,
                                networkType: NumOfSymbol.NetworkType.mainnet,
                                fee: 160000,
                                deadLine: 7200,
                                recipientAddress: "NACW73ZWAD6RGZPC3P64DN3KYK5XDLLMVGHW2KQ",
                                message: getOmikuji(),
                                mosaicID: "F82302A23F91ED6B",
                                amount: 100000000)
                                            
                            Task{
                                guard let response = try await t.sendPayload() else { return }
                                if response.contains("pushed") {
                                    self.isSend = true
                                }
                            }
                            
                        }) {
                            Text("100XYM")
                                .bold()
                                .padding()
                                .frame(width: 100, height: 50)
                                .foregroundColor(Color.white)
                                .background(Color.blue)
                                .cornerRadius(25)
                        }
                        .alert(isPresented: $isAlert) {
                            Alert(title: Text("秘密鍵がありません"),
                                  message: Text("右下の歯車のマークより保存してください"),
                                  dismissButton: .default(Text("ガッテン")))
                        }
                        .alert(isPresented: $isSend) {
                            Alert(title: Text("トランザクションを送信しました"),
                                  //message: Text("右下の歯車のマークより保存してください"),
                                  dismissButton: .default(Text("OK")))
                        }
                        
                    }
                    
                    
                    HStack{
                        Spacer()
                        Text("自己保有:\(XYMAmount_ME) XYM")
                        Spacer()
                        Button(action:{
                            self.showModal.toggle()
                        }){
                            Image(systemName: "gear")
                        }.sheet(isPresented: $showModal){
                            savePrivateKey(presented: $showModal, privateKey: "")
                        }
                        Spacer()
                        
                    }
                    .padding()
                    
                }
                
                
            }
            .padding()
            .onAppear{
                let cm:CommonMethod = CommonMethod()
                timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
                                    //self.count += 1
                    Task{
                        XYMAmount_ME = try! await cm.getXYMMount(address: "NACW73ZWAD6RGZPC3P64DN3KYK5XDLLMVGHW2KQ")
                        XYMAmount_TARGET =  try! await  cm.getXYMMount(address: "NBRK37LX76UXUFUNOYUZYMSTOT4G7KYIXK3VHOI")
                        
                        XYMAmount_TARGET += 10
                        
                    }
                    
                    //XYMAmount_TARGET += 1000
                    /*
                    withAnimation(Animation.spring().speed(0.2)) {
                                    animate.toggle()
                                }
                     
                     */
                    
                    
                    
                }
                
            }//.navigationBarTitle("オラにXYMを分けてくれ", displayMode: .inline)
            
            
        }
        
        
        
        
        
        
    }
    
    func getOmikuji() -> String{
        let omikuji:[String] = ["大吉","中吉","小吉","末吉","吉","凶","大凶"]
        let value = Int.random(in: 0...6)
        
        return omikuji[value]
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 extension Binding where Value == Double {
 func DoubleToStrDef(_ def: Double) -> Binding<String> {
 return Binding<String>(get: {
 return String(self.wrappedValue)
 }) { value in
 self.wrappedValue = Double(value) ?? def
 }
 }
 }
 */
