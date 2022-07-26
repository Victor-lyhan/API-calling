//
//  ContentView.swift
//  API calling
//
//  Created by Victor Han on 2022/7/26.
//

import SwiftUI

struct ContentView: View {
    @State private var foods = [Food]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(foods) { food in
                VStack{
                    NavigationLink {
                        Text("\(food.price) dollars")
                        Text(food.description)
                    } label: {
                        Text(food.name)
                    }
                }
            }
            .navigationTitle("Foods")
        }
        .onAppear {
            getFoods()
        }
        .alert(isPresented: $showingAlert){
            Alert(title: Text("Loading Error"),
                  message: Text("there was a problem loading the data"),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    func getFoods() {
        let apiKey = "?rapidapi-key=d582ffb81bmsh2b53131e0f4dbedp18510bjsnea5f7f34cb91"
        let query = "https://pizza-and-desserts.p.rapidapi.com/desserts\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                    let contents = json.arrayValue
                    for item in contents {
                        let name = item["name"].stringValue
                        let price = item["price"].stringValue
                        let description = item["description"].stringValue
                        let food = Food(name: name, price: price, description: description)
                        foods.append(food)
                    }
                    return
            }
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Food: Identifiable {
    let id = UUID()
    var name = ""
    var price = ""
    var description = ""
}
