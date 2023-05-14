//
//  UserProfile2.swift
//  Amore
//
//  Created by Kshitiz Sharma on 5/12/23.
//

import SwiftUI

struct UserProfile2: View {
    @State private var selectedSubscription: Subscription?
    
    let consumables: [Consumable]
    
    init() {
        // Load JSON data from file or network
        guard let url = Bundle.main.url(forResource: "Consumables", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: []),
              let consumablesJson = json as? [[String: Any]] else {
            print("Failed to load JSON data")
            consumables = []
            return
        }
        
        // Map JSON data to array of Consumable structs
        consumables = consumablesJson.map { consumableJson -> Consumable in
            let iconName = consumableJson["iconName"] as? String
            let name = consumableJson["name"] as? String
            let count = consumableJson["count"] as? String
            return Consumable(iconName: iconName, name: name, count: count)
        }
    }
    
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                
                // User info section
                VStack(spacing: 1) {
                    Image("BlogArticle1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width * 0.40, height: geo.size.width * 0.40)
                        .clipShape(Circle())
                    
                    VStack(alignment: .center, spacing: 3) {
                        Text("John Doe")
                            .font(.title2)
                        Text("Film Director")
                            .foregroundColor(.gray)
                        Text("Graduated from USC School of Cinematic Arts")
                            .foregroundColor(.gray)
                        Text("Current subscription: Premium")
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 5) {
                            Button(action: {
                                // Handle Edit Profile button tap
                            }) {
                                HStack(spacing:3) {
                                    Text("Edit Profile")
                                }
                                .foregroundColor(Color.primary)
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            }
                            
                            Button(action: {
                                // Handle Settings button tap
                            }) {
                                Image(systemName: "gear")
                                    .foregroundColor(Color(UIColor.systemGray))
                                    .font(.title2)
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(22)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Safety and Verify Profiles
                VStack(spacing: 5) {
                    Text("Safety First")
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        HStack(spacing:5)  {
                            Image(systemName: "shield.fill")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                            Text("Safety")
                        }
                        .padding(10)
                        .frame(width:geo.size.width * 0.5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)

                        HStack(spacing:5)  {
                            Image(systemName: "person.badge.shield.checkmark.fill")
                                .font(.title2)
//                                .foregroundColor(Color.gray)
                                .foregroundColor(Color.green)
                            Text("Verify Profile")
                        }
                        .padding(10)
                        .frame(width:geo.size.width * 0.5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                
                Spacer()
                
                // Consumables
                VStack(spacing: 5) {
                    Text("Consumables")
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    // Consumables section
                    ConsumablesGrid(consumables:consumables, boxWidth:(geo.size.width - 20) / 4)
                }
                
                Spacer()
                
                // Subscription section
                VStack(spacing: 5) {
                    Text("Subscriptions")
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(Subscription.allCases, id: \.self) { subscription in
                        SubscriptionRowView(subscription: subscription, isSelected: subscription == selectedSubscription)
                            .onTapGesture {
                                selectedSubscription = subscription
                            }
                    }
                }
                
            }
        }
        .padding(.horizontal)
    }
}


struct UserProfile2_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile2()
    }
}


struct SubscriptionRowView: View {
    let subscription: Subscription
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(subscription.rawValue)
                    .font(.headline)
                Text(subscription.description)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("$\(subscription.price)/month")
                .font(.headline)
                .foregroundColor(.accentColor)
        }
        .padding()
        .background(isSelected ? Color.accentColor.opacity(0.2) : Color.secondary.opacity(0.2))
        .cornerRadius(10)
    }
}

enum Subscription: String, CaseIterable {
    case basic = "Basic"
    case premium = "Premium"
    case ultimate = "Ultimate"
    
    var description: String {
        switch self {
        case .basic:
            return "Access to basic features"
        case .premium:
            return "Access to premium features"
        case .ultimate:
            return "Access to all features"
        }
    }
    
    var price: Int {
        switch self {
        case .basic:
            return 9
        case .premium:
            return 19
        case .ultimate:
            return 29
        }
    }
}


struct ConsumablesGrid: View {
    
    @State var consumables: [Consumable]
    @State var boxWidth: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            let boxWidth = (geo.size.width - 20) / 4
            HStack {
                ForEach(consumables) { consumable in
                    VStack(spacing:2) {
                        Image(systemName: consumable.iconName ?? "message.circle.fill")
                            .font(.title)
                            .foregroundColor(.accentColor)
                        Text(consumable.count ?? "")
                    }
                    .padding([.top, .bottom], 10)
                    .frame(width: boxWidth)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
            }
        }
    }
}

struct Consumable: Identifiable  {
    var id = UUID()
    var iconName: String?
    var name: String?
    var count: String?
}
