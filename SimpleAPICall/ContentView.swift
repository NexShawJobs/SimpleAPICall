//
//  ContentView.swift
//  SimpleAPICall
//
//  Created by NebSha on 1/4/24.
//

import SwiftUI

struct ContentView: View {
    @State private var user:GitHubUser?
    var body: some View {
        VStack {

            AsyncImage(url: URL(string: user?.avatarUrl ?? " ")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
            }
            .frame(width: 120, height: 120)


            Text(user?.login ?? "Login place holder.")
                .bold()
                .font(.title3)
//            Text(user?.bio ?? "Bio place holder")
//                .padding()
            Spacer()
        }
        .padding()
        .task {
            do {
                user = try await getUser()
            }  catch {
                GHError.invalidUrl
                print("Invalid Url")
            } catch {
                GHError.invalidData
                print("Invalid Data")
            } catch {
                GHError.invalidResponse
                print("Invalid Response")
            } catch {
                print("Unexpected Eerror")
            }
            
        }
    }
    func getUser() async throws -> GitHubUser {
        let endpoint = "https://api.github.com/users/NexShawJobs" //sallen0400
    // let endpoint = "https://api.github.com/users/sallen0400"

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
            print(decoder)
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
    let avatarUrl: String
    //let bio: String
    
}
