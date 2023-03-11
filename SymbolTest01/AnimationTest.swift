//
//  AnimationTest.swift
//  SymbolTest01
//
//  Created by 岡田貴紀 on 2023/02/28.
//

import SwiftUI

struct AnimationTest: View {
    
    @State private var showDetail:Bool = false
    @State var isAnimation = false
    
    var body: some View {
        
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            Rectangle()
                .frame(width: 123,height: 123)
                .rotationEffect(Angle(degrees: self.isAnimation ? 360:0))
                .onAppear() {
                    withAnimation(
                        Animation
                            .linear(duration: 1)
                            .repeatForever(autoreverses: false)
                    ) {
                        self.isAnimation.toggle()
                    }
                }
            
            Button {
                showDetail.toggle()
            } label: {
                Label("Graph", systemImage: "chevron.right.circle")
                    .labelStyle(.iconOnly)
                    .imageScale(.large)
                    .rotationEffect(.degrees(showDetail ? 90 : 0))
                    .padding()
                    .animation(.easeInOut, value: showDetail)
            }
            
            
        }
        
        
        
    }
}

struct AnimationTest_Previews: PreviewProvider {
    static var previews: some View {
        AnimationTest()
    }
}
