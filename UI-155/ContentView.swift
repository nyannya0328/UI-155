//
//  ContentView.swift
//  UI-155
//
//  Created by にゃんにゃん丸 on 2021/04/02.
//

import SwiftUI

var gra = LinearGradient(gradient: .init(colors: [.blue,  .orange]), startPoint: .leading, endPoint: .trailing)

var ang = AngularGradient(gradient: .init(colors: [.yellow,.purple]), center: .center)

var rad = RadialGradient(gradient: .init(colors: [.green,.pink]), center: .center, startRadius: 5, endRadius: 500)

struct ContentView: View {
    var body: some View {
        NavigationView{
            MainView()
                .navigationBarHidden(true)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    @State var offset : CGPoint = .zero
    var body: some View{
        
        
        NavigationView{
            
            CustomScrollView(offset: $offset, showIndicator: true, axis: .horizontal, content: {
                
                HStack{
                    
                    ForEach(1...10,id:\.self){_ in
                        
                        
                        HStack(spacing:10){
                            
                            
                            Circle()
                                .fill(ang)
                                .frame(width: 70, height: 70)
                            
                            VStack(alignment: .leading, spacing: 10, content: {
                                Rectangle()
                                    .fill(gra)
                                    .frame(height: 15)
                                
                                Rectangle()
                                    .fill(rad)
                                    .frame(height: 15)
                                    .padding(.trailing,30)
                                    
                            })
                            .frame(width: 70)
                        }
                        .padding(.horizontal)
                    }
                    
                }
                .padding(.top)
                
                
                
            })
            .navigationTitle("offset:\(String(format: "%.1f", offset.x))")
            
            
            
        
        }
    }
}

struct CustomScrollView<Content:View> : View {
    
    @Binding var offset : CGPoint
    
    var content : Content
    var showIndicator : Bool
    var axis : Axis.Set
    
    init(offset : Binding<CGPoint>,showIndicator : Bool,axis:Axis.Set,@ViewBuilder content :()-> Content) {
        self.content = content()
        self._offset = offset
        self.showIndicator = showIndicator
        self.axis = axis
    }
    
    @State var startOffset : CGPoint = .zero
    
    var body: some View{
        
        ScrollView(axis, showsIndicators: showIndicator, content: {
            content
            
            
                .overlay(
                
                    GeometryReader{proxy -> Color in
                        
                        let rect = proxy.frame(in: .global)
                        
                        if startOffset == .zero{
                            
                            
                            DispatchQueue.main.async {
                                
                                startOffset = CGPoint(x: rect.minX, y: rect.minY)
                                
                                
                            }
                            
                           
                            
                            
                        }
                        
                        
                        DispatchQueue.main.async {
                            self.offset = CGPoint(x: startOffset.x - rect.minX, y: startOffset.y - rect.minY)
                        }
                        
                        return Color.clear
                        
                        
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 0)
                    ,alignment: .top
                )
        })
    }
    
}
