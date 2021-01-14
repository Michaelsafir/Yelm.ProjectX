//
//  images.swift
//  Yelm.ProjectX
//
//  Created by Michael on 13.01.2021.
//

import Foundation
import SwiftUI
import Photos



struct ModalImages: View {
    
    
    @State var selected : [selected_images] = []
    @State var grid : [images] = []
    @State var height : CGFloat = 150
    
    @ObservedObject var realm: RealmLocations = GlobalRealmLocations
    @ObservedObject var modal : ModalManager = GlobalModular
    @ObservedObject var location : location_cache = GlobalLocation
    
    
    @State var disabled = false
    
    
    @State var showmap : Bool = false
    
    
    
    func check(id: Int, x: CGFloat) -> Bool {
        
        let results = selected.filter { $0.id == id }
        let exists = results.isEmpty == false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if (x < -100){
                print("remove index")
                loaded_images_ids.removeAll{$0 == id}

            }
            
            if (x > UIScreen.main.bounds.width + 100){
                print("remove image")
                
                if (check_image(key: id)){
                    loaded_images_images[id] = nil
                }

            }
        }
        
        if (x < -100){
            print("remove index")
            loaded_images_ids.removeAll{$0 == id}

        }
        
        if (x > UIScreen.main.bounds.width + 100){
            print("remove image")
            
            if (check_image(key: id)){
                loaded_images_images[id] = nil
            }

        }
        
        return exists
    }
    
    func get_images(){
        
        let options_fetch = PHFetchOptions()
        options_fetch.sortDescriptors =  [NSSortDescriptor(key: "creationDate", ascending: false)]
        options_fetch.fetchLimit = 300
        
        
        let req = PHAsset.fetchAssets(with: .image, options: options_fetch)
        
        DispatchQueue.global().asyncAfter(deadline: .now()) {
            
            var id = 0
            req.enumerateObjects { (asset, _, _) in
                
                let options = PHImageRequestOptions()
                options.isSynchronous = false
                options.deliveryMode = PHImageRequestOptionsDeliveryMode.fastFormat
                options.isNetworkAccessAllowed = true
                
                options.progressHandler = {  (progress, error, stop, info) in
                    print("progress: \(progress)")
                }
                
                
                let images_data = images(id: id, image_asset: asset)
                id += 1
                
                DispatchQueue.main.async {
                    self.grid.append(images_data)
                }
                
                
            }
            
        }
    }
    
    func scaledWidth(image: UIImage) -> CGFloat {
        
        if (self.selected.count > 0){
            let size_aspect = image.size
            
            let ratio = size_aspect.width / size_aspect.height;
            
            let new_height : CGFloat =  150
            
            let new_width = new_height * ratio;
            
            return new_width
        }
        
        return 80
    }
    
    var body: some View {
        
        VStack(){
            Spacer()
            
            HStack{
                Spacer()
                Rectangle()
                    .background(Color.gray)
                    .cornerRadius(10)
                    .frame(width: 30, height: 5)
                    .opacity(0.4)
                Spacer()
            }.padding(.bottom, 5)
            VStack{
                VStack(){
                    Text("")
                        .frame(width: 10, height: 20)
                    HStack{
                        Text("Фотографии")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        Spacer()
                    }
                }.padding(.horizontal, 20)
                
                VStack{
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            
                            ZStack{
                                CustomCameraView()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(10)
                                    .padding(.trailing, 4)
                                
                                Image(systemName: "camera")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(Color.init(hex: "F2F3F4"))
                            }
                            
                            
                            ForEach(self.grid, id: \.self){ image in
                                
                                GeometryReader{ geo in
                                    if (geo.frame(in: .global).minX > -400 && geo.frame(in: .global).minX  < UIScreen.main.bounds.size.width+400){
                                        
                                         
                                            ZStack(alignment: .topTrailing){
                                                VStack{

                                                    ImageLoaderLibrary(id: image.id, asset: image.image_asset)
                                                        



                                                }
                                                .frame(width: 80, height: 80)
                                                .clipShape(CustomShape(corner: .allCorners, radii: 10))


                                                Image(systemName: check(id: image.id, x: geo.frame(in: .global).minX) ?  "checkmark.circle.fill" : "circle")
                                                    .renderingMode(check(id: image.id, x: geo.frame(in: .global).minX) ? .original : .template)
                                                    .foregroundColor(!check(id: image.id, x: geo.frame(in: .global).minX) ? Color.init(hex: "F2F3F4") : Color.theme)
                                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                                    .frame(width: 20, height: 20)
                                                    .offset(x: -11, y: 6)

                                            }
                                 
                                            .clipShape(CustomShape(corner: .allCorners, radii: 10))
                                            .padding(.trailing, 4)
                                            
                                            .onTapGesture() {

                                                print(self.grid.count)
                                                if (check(id: image.id, x: geo.frame(in: .global).minX)){

                                                    selected.removeAll{$0.id == image.id}

                                                }else{
                                                    self.selected.append(selected_images(id: image.id, image_asset: image.image_asset))
                                                }

                                            }
                                        
                                    }
                                    
                                }.frame(width: 80)
                            }
                            
                            Text("")
                                .padding(.trailing, 10)
                            
                        }
                        
                        .padding(.leading, 20)
                    }.padding(.bottom, 10)
                    
                }.frame(height: 80)
                
                VStack{
                    HStack{
                        
                        Button(action: {
                            
                        }) {
                            HStack{
                                Spacer()
                                Text("Отправить: (\(selected.count))")
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }.buttonStyle(ScaleButtonStyle())
                        
                    }.padding(.bottom, 30)
                    
                    
                }.padding(.horizontal, 20)
            }
            //            .frame(width: UIScreen.main.bounds.width, alignment: .center)
            .background(Color.white)
            .cornerRadius(30)
            //            .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 30))
        }
        //        .frame(width: UIScreen.main.bounds.width)
        
        .onAppear {
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                if status == .authorized{
                    
                    self.get_images()
                    self.disabled = false
                }
                else{
                    
                    print("not authorized")
                    self.disabled = true
                }
            }
        }
        
        
    }
}

var loaded_images_ids : [Int] = []
var loaded_images_images : [Int : UIImage] = [:]



func check_image(key: Int) -> Bool {
    
    if let _ = loaded_images_images[key] {
        return true
    }
    else {
        return false
    }
    
    return false
}
struct ImageLoaderLibrary: View {
    
    @State var id : Int = 0
    @State var image : UIImage = UIImage(systemName: "photo")!
    @State var asset : PHAsset
    @State var process : Bool = false
    
    var body: some View {
        VStack{
            if (self.process){
                Image(uiImage: self.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
            }else{
                VStack{
                    Image(systemName: "photo")
                        .resizable()
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Color.init(hex: "F2F3F4"))
                        .aspectRatio(contentMode: .fit)
                }
                    .frame(width: 80, height: 80)
            }
               
            
        }.onAppear{
            

           
            
            if (!loaded_images_ids.contains(self.id) && check_image(key: self.id) == false){


                DispatchQueue.global(qos: .utility).async {




                    let options = PHImageRequestOptions()
                    options.isSynchronous = true
                    options.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
                    options.isNetworkAccessAllowed = true

                    options.progressHandler = {  (progress, error, stop, info) in
                        print("progress: \(progress)")
                    }


                    PHImageManager.default().requestImage(for: asset, targetSize: .init(), contentMode: .aspectFill, options: options) { (image, _) in


                        
                        if let image_ready = image {
                            
                            let compressed = UIImage(data: image_ready.jpeg(.lowest)!)

                            DispatchQueue.main.async {
                                self.image = compressed!
                                self.process = true
                                loaded_images_ids.append(self.id)
                                loaded_images_images[self.id] = compressed
                            }
                        


                        }



                    }

                }

            }else{
                print("im get all from cache")
                if (check_image(key: self.id)){
                    self.image = loaded_images_images[self.id]!
                    self.process = true
                }
            
                
                
            }

            
            
            
            
        }
    }
}


extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
           return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
