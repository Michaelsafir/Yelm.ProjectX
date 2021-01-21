//
//  cart.swift
//  Yelm.ProjectX
//
//  Created by Michael on 09.01.2021.
//

import Foundation
import SwiftUI

struct Cart: View {
    
    @State var nav_bar_hide: Bool = true
    @ObservedObject var realm: RealmControl = GlobalRealm
    @ObservedObject var cart: cart = GlobalCart
    @ObservedObject var bottom: bottom = GlobalBottom
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        
        
        VStack{
            
            
            ZStack(alignment: .bottom){
                VStack {
                    
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
                            
                            Text("Корзина")
                                .padding(.top, 10)
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                            
                            
                            Spacer()
                            
                            Button(action: {
                                
                                self.realm.clear_cart()
                                
                                let generator = UIImpactFeedbackGenerator(style: .soft)
                                generator.impactOccurred()
                                
                            }) {
                                Text("Очистить")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(.secondary)
                                
                            }
                            .padding(.top, 10)
                            .padding(.trailing, 10)
                            .buttonStyle(ScaleButtonStyle())
                            
                        }
                        
                        
                        
                    }
                    .padding([.trailing, .leading], 20)
                    .padding(.bottom, 10)
                    .clipShape(CustomShape(corner: [.bottomLeft, .bottomRight], radii: 20))
                    .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                    .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                    
                    //                if (self.realm.hasSomething) {
                    
                    
                    
                    ScrollView(showsIndicators: false) {
                        
                        ForEach(self.cart.cart_items, id: \.self){ item in
                            CartItem(id: item.id,
                                     title: item.title,
                                     image: item.image,
                                     price: item.price,
                                     price_float: item.price_float,
                                     type: item.type,
                                     quanity: item.quantity)
                                
                                .padding([.trailing, .leading], 20)
                        }

                        VStack{
                            HStack(spacing: 0){
                                
                                
                                
                                VStack(alignment: .leading, spacing: 5){
                                    Text("Доставка")
                                        .lineLimit(2)
                                        
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    
                                    
                                    Text("Закажите еще на 300 рублей для бесплатной доставки")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .lineLimit(2)
                                        .frame(height: 40)
                                    
                                    
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing){
                                    Text("150 ₽")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.theme)
                                    
                                } .padding(.horizontal, 10)
                                
                                
                            }.padding([.top, .bottom], 5)
                            Divider()
                        }.padding([.trailing, .leading], 20)
                        
                        Spacer(minLength: 150)
                        
                        
                    }
                    
                    
                    Spacer()
                    
                    
                }
                
                VStack(spacing: 0){
                    HStack(spacing: 15){
                        VStack(spacing: 5){
                            Text("\(String(format:"%.2f", self.realm.price)) ₽")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.theme)
                            Text("15-20 мин")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        
                        
                        
                        
                        NavigationLink(destination: Offer()) {
                            HStack{
                                Spacer()
                                Text("Оформить")
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.theme)
                            .foregroundColor(.theme_foreground)
                            .cornerRadius(10)
                            
                        }.buttonStyle(ScaleButtonStyle())
                        .simultaneousGesture(TapGesture().onEnded{
                            open_offer = true
                        })
                        
                        
                        
                        
//                        Кнопка для покупки
//                        Данные о сумме заказа
                    }.padding([.trailing, .leading], 20)
                }
                .padding(.bottom, 40)
                .padding(.top, 30)
                .background(Color.white)
                .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 20))
                //                .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                .shadow(color: .dropShadow, radius: 15, x: 0, y: 2)
                
            }
            
        }
        
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        .edgesIgnoringSafeArea(.bottom)
        
        .onAppear {
            self.realm.objectWillChange.send()
            self.bottom.hide = true
            self.nav_bar_hide = true
        }
        
        .onDisappear{
            if (open_offer == false){
                self.bottom.hide = false
            }
            
        }
        
        
    }
    
}
