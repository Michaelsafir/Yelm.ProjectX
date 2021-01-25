//
//  payment.swift
//  Yelm.ProjectX
//
//  Created by Michael on 24.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server
import Yelm_Pay

struct Payment: View {
    

    @ObservedObject var realm: RealmControl = GlobalRealm
    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var item: items = GlobalItems
    @State var nav_bar_hide: Bool = true
    
    
    @State var card: String = ""
    @State var date: String = ""
    @State var cvv: String = ""

    @Environment(\.presentationMode) var presentation
    

    
    var body: some View {
        
        
        
        ZStack(alignment: .bottom){
            VStack{

                
                VStack{
                    
                        HStack(alignment: .center){
                            Button(action: {
                                
                                    self.presentation.wrappedValue.dismiss()
                                    let generator = UIImpactFeedbackGenerator(style: .soft)
                                    generator.impactOccurred()
                             
                            }) {

                                Image(systemName: "arrow.backward")
                                    .foregroundColor(Color.theme_foreground)
                                    .frame(width: 15, height: 15, alignment: .center)
                                    .padding([.top, .leading, .bottom, .trailing], 10)

                                    .font(.system(size: 15, weight: .bold, design: .rounded))

                                    .background(Color.theme)
                                    .clipShape(Circle())

                            }
                                .padding(.top, 10)
                                .padding(.trailing, 10)
                                .buttonStyle(ScaleButtonStyle())
                            
                            Text("Оплата")
                                .padding(.top, 10)
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                             
                            
                            Spacer()
                        }
                        
                     
                    
                }
                .padding([.trailing, .leading], 20)
                .padding(.bottom, 10)
                .clipShape(CustomShape(corner: [.bottomLeft, .bottomRight], radii: 20))
                .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                
                
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60, alignment: .center)
                    .clipShape(CustomShape(corner: .allCorners, radii: 10))
                    .padding()
                
                
                VStack(spacing: 0){
                    
                    
                    
                    PaymentHeader()
                    
                    
                    VStack(spacing: 0){
                        TextField("Номер карты", text: $card)
                            .padding(.vertical, 5)
                            .foregroundColor(Color.init(hex: "828282"))
                            .background(Color.init(hex: "FBFCFC"))
                        
                        Line().fill(Color.init(hex: "AEADAD").opacity(0.5)).frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                    }
                    .padding(.bottom, 20)
                    .padding(.horizontal, 2)

                    
                    HStack(spacing: 25){
                        
                        VStack(spacing: 0){
                            TextField("MM/YY", text: $date)
                                .padding(.vertical, 5)
                                .foregroundColor(Color.init(hex: "828282"))
                                .background(Color.init(hex: "FBFCFC"))
                            
                            Line().fill(Color.init(hex: "AEADAD").opacity(0.5)).frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                        }
                        
                        
                        VStack(spacing: 0){
                            SecureField("CVV", text: $cvv)
                                .padding(.vertical, 5)
                                .foregroundColor(Color.init(hex: "828282"))
                                .background(Color.init(hex: "FBFCFC"))
                            
                            Line().fill(Color.init(hex: "AEADAD").opacity(0.5)).frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                        }
                    }
                    .padding(.bottom, 25)
                    .padding(.horizontal, 2)
                    
                    HStack{
                        
                        Image(systemName: "checkmark.square.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                        
                        Text("Запомнить карту")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.init(hex: "828282"))
                        
                        Spacer()
                      
                    }
                    .padding(.horizontal, 2)
                    .padding(.bottom, 15)
                        
                        
                    
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.init(hex: "FBFCFC"))
                .clipShape(CustomShape(corner: .allCorners, radii: 20))
                .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                .padding([.trailing, .leading], 20)
                
                
                VStack(spacing: 15){
                    Text("700 \(ServerAPI.settings.symbol)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Button(action: {
                        

                    }) {
                        
                        HStack{
                            Text("Оплатить")
                                .font(.system(size: 22))
                                .padding(.horizontal, 60)
                        }
                            .padding(.horizontal)
                            .padding(.vertical, 15)
                            .background(Color.theme)
                            .foregroundColor(.theme_foreground)
                            .cornerRadius(10)
                         


                    }

                    .frame(height: 50)
                    .buttonStyle(ScaleButtonStyle())
                    .clipShape(CustomShape(corner: .allCorners, radii: 10))
                    
                    
                    Text("Нажимая кнопку «Оплатить», Вы соглашаетесь с офертой")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.init(hex: "828282"))
                        .multilineTextAlignment(.center)
                    
                }.padding()
                
                Spacer()
                

                
                
                
                
            }
            
            
        }.edgesIgnoringSafeArea(.bottom)
        
        
      
    
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        
        
        .onAppear {
            self.nav_bar_hide = true
            self.bottom.hide = true
           
       }
       
     
        .onDisappear{
            open_offer = false
        }
       

    }
}


struct PaymentHeader: View {
    var body: some View {
        HStack{
            
            Image("master")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 20)
            
            Image("visa")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .padding(.trailing, 6)
            
            Image("mir")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 20)
                .padding(.trailing, 5)
            
            Spacer()
        }
    }
}


struct Line: Shape {

    func path(in rect: CGRect) -> Path {

        let fill = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        var path = Path()
        path.addRoundedRect(in: fill, cornerSize: CGSize(width: 2, height: 2))

        return path
    }
}