import SwiftUI

struct MatchViewParent: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            
            VStack {
                Spacer()
                
                HStack(spacing: 30) {
                    ZStack {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.6)
                            .cornerRadius(10) // Set corner radius to round the edges
                            .padding(.top, 30)
                            .rotationEffect(Angle(degrees: 10))
                            .offset(x: 180, y:05)
                            .overlay(
                                Image("malmatch")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.6)
                                    .cornerRadius(10) // Set corner radius to round the edges
                                    .padding(.top, 30)
                                    .rotationEffect(Angle(degrees: 10))
                                    .offset(x: 180, y: 05)
                            )
                            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 10, x: 10, y: 5) // Add shadow to this rectangle

                        Circle()
                            .frame(width: 80, height: 80) // Set size of the circle
                            .foregroundColor(colorScheme == .dark ? Color.black : Color.white) // Set color of the circle
                            .overlay(
                                Circle()
                                    .stroke(Color.pink, lineWidth: 2) // Add pink boundary around the circle
                                    .frame(width: 80, height: 80)
                            )
                            .offset(x: UIScreen.main.bounds.width * 0.24, y: UIScreen.main.bounds.width * 0.51) // Set offset of the circle from top left corner
                            .overlay(
                                Image(systemName: "heart.fill") // Set image of heart as overlay
                                    .resizable()
                                    .foregroundColor(.red) // Set color of the circle
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60) // Set size of the heart image
                                    .offset(x: UIScreen.main.bounds.width * 0.24, y: UIScreen.main.bounds.width * 0.52) // Set offset of the circle from top left corner
                            )
                            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 3, x: 10, y: 5)

                    }

                    ZStack {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.6)
                            .cornerRadius(10) // Set corner radius to round the edges
                            .padding(.top, 30)
                            .rotationEffect(Angle(degrees: -10))
                            .offset(x: -180, y: 110)
                            .overlay(
                                Image("femmatch")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.6)
                                    .cornerRadius(10) // Set corner radius to round the edges
                                    .padding(.top, 30)
                                    .rotationEffect(Angle(degrees: -10))
                                    .offset(x: -180, y: 110)
                            )
                            .padding(.bottom, 200)
                            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 10, x: 10, y: 5) // Add shadow to this rectangle

                    }
                }

                
                Text("It's a match, Jake!")
                    .font(Font.system(size: 40)) // Set custom font size
                    .fontWeight(.bold)
                    .foregroundColor(.pink) // Set text color to pink
                    .padding(.top, 30)

                Text("Start a conversation with one another")
                    .font(.subheadline)
                    .foregroundColor(.pink) // Set text color to pink

                
                Spacer()
                
                VStack(spacing: 20) {
                    Button(action: {
                        // Action to take when "Say Hello" button is tapped
                    }) {
                        Text("Say Hello")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300, height: 60) // Set button width and height
                            .background(Color.pink) // Set button background color to pink
                            .cornerRadius(20) // Set corner radius to round the edges
                    }
                    
                    
                    Button(action: {
                        // Action to take when "Keep Swiping" button is tapped
                    }) {
                        Text("Keep Swiping")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                            .padding()
                            .frame(width: 300, height: 60) // Set button width and height
                            .background(colorScheme == .dark ? Color.black : Color.white) // Set button background color to cream
                            .cornerRadius(20) // Set corner radius to round the edges
                            .border(Color.pink, width: 2) // Add pink border with a width of 2 points
                            .cornerRadius(20) // Round the edges of the border
                            .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.pink, lineWidth: 2) // Add pink border with a width of 2 points
                                    )
                    }
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 50)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MatchViewParent_Previews: PreviewProvider {
    static var previews: some View {
        MatchViewParent()
    }
}
