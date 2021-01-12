//
//  search.swift
//  Yelm.ProjectX
//
//  Created by Michael on 10.01.2021.
//

import Foundation
import SwiftUI
import Combine


struct Search: View {
    
    
    @State var selection: Int? = nil
    @ObservedObject var item: items = GlobalItems

    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var realm: RealmControl = GlobalRealm
    @ObservedObject var search_server : search = GlobalSearch

    @State var nav_bar_hide: Bool = true
    
    
    @Environment(\.presentationMode) var presentation
    
    @State var search : String = ""
    var body: some View {
        VStack{
            
            VStack{
                
                    HStack(alignment: .center){
                        Button(action: {
                            
                                self.presentation.wrappedValue.dismiss()
                                let generator = UIImpactFeedbackGenerator(style: .soft)
                                generator.impactOccurred()
                         
                        }) {

                            Image(systemName: "arrow.backward")
                                .foregroundColor(Color.white)
                                .frame(width: 15, height: 15, alignment: .center)
                                .padding([.top, .leading, .bottom, .trailing], 10)

                                .font(.system(size: 15, weight: .bold, design: .rounded))

                                .background(Color.blue)
                                .clipShape(Circle())

                        }
                            .padding(.top, 10)
                            .padding(.trailing, 10)
                            .buttonStyle(ScaleButtonStyle())
                        
                        Text("Поиск товаров")
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

           
                
            SearchBar(text: $search)
                .padding(.bottom)
                .padding(.horizontal, -10)
            
            
            ScrollView(showsIndicators: false){
                
                
                ForEach(self.search_server.items.filter { $0.title.lowercased().contains(search.lowercased()) || search.isEmpty || $0.title.lowercased().contains(search.lowercased())}, id: \.self) { tag in
                    NavigationLink(destination: Item(), tag: 7, selection:  $selection){
                        SearchItem(title: tag.title, image: tag.thubnail, price: tag.price, type: tag.type, quanity: tag.quanity)
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        let item = tag
                        open_item = true
                        self.item.item = item
                    })
                    
                }

            }.frame(width: UIScreen.main.bounds.size.width-30)
            
            Spacer()
        }
        
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        
        .onAppear {
            self.nav_bar_hide = true
            self.bottom.hide = true
        }
        
        .onDisappear{
            if (open_item == false){
                self.bottom.hide = false
            }
        }
    }
}