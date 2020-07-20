//
//  ContentView.swift
//  DAMII_Examen_Calderon_Erazo
//
//  Created by DAMII on 7/19/20.
//  Copyright © 2020 Cibertec. All rights reserved.
//
import SwiftUI

struct StephConsulResponse: Decodable {
    let photos: Photos
}

struct Photos: Decodable{
    let photo: [Photo]
}

struct Photo: Identifiable, Decodable {
    let id = UUID().uuidString
    let title: String
    let datetaken: String
}

class StephConsulViewModel: ObservableObject {
    @Published var photos = [Photo]()
    func getConsul(){
        let stringUrl = "https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=a6d819499131071f158fd740860a5a88&extras=url_z,date_taken&format=json&nojsoncallback=1"

        let url = URL(string: stringUrl)!

         let session = URLSession.shared
        session.dataTask(with: url){
            (data, response, error) in
            DispatchQueue.main.async {
                self.photos = try! JSONDecoder().decode(StephConsulResponse.self, from: data!).photos.photo
            }
        }.resume()
    }
}

struct ConsulRowView: View {
    let photos: Photo
    var body: some View {
        VStack{
            Text(photos.title)
            Text(photos.datetaken)
        }
    }
}

struct ContentView: View {
    
    @ObservedObject var StephConsulVM = StephConsulViewModel()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(StephConsulVM.photos) { photos in
                    ConsulRowView(photos: photos)
                }
            }.navigationBarTitle(Text("StephConsul"))
        }.onAppear{
            self.StephConsulVM.getConsul()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
