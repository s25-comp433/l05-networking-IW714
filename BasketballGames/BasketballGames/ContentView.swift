//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Game: Codable {
    var team: String
    var isHomeGame: Bool
    var id: Int
    var score: Score
    var date: String
    var opponent: String
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var results = [Game]()
    
    var body: some View {
        NavigationStack {
            List(results, id: \.id) { game in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(game.team) vs. \(game.opponent)")
                        Text(game.date)
                            .font(.caption)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(game.score.unc) - \(game.score.opponent)")
                        Text(game.isHomeGame ? "Home" : "Away")
                            .font(.caption)
                    }
                }
            }
            .task {
                await fetchData()
            }
            .navigationTitle(Text("UNC Basketball"))
        }
    }
    
    func fetchData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString) // Print raw JSON response
            }
            
            if let decoderResponse = try? JSONDecoder().decode([Game].self, from: data) {
                results = decoderResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
