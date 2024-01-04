//
//  ContentView.swift
//  SimpleAPICall
//
//  Created by NebSha on 1/4/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Circle()
                .foregroundColor(.secondary)
                .frame(width: 120, height: 120)
            Text("Username")
                .bold()
                .font(.title3)
            Text("This is where the Github bio will go. lets make it long so it spans two lines.")
                .padding()
            Spacer()
        }
        .padding()
    }
    func getUser() async throws -> GitHubUser {
        let endpoint = "https://api.github.com/users/NexShawJobs" //sallen0400
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
}

#Preview {
    ContentView()
}


enum GHError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}
//CREATE A MODEL

struct GitHubUser: Codable {
    let login: String
    let avatar_url: String
    let bio: String
    
}
