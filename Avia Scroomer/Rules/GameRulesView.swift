import SwiftUI

struct GameRulesView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("close_btn")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                Spacer()
                
                ZStack {
                    Image("value_bg")
                        .resizable()
                        .frame(width: 140, height: 50)
                    Text("\(userData.credits)")
                        .font(.custom("Rubik-Bold", size: 24))
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            Spacer()
            
            Image("rules_title")
                .resizable()
                .frame(width: 350, height: 80)
            
            Text("You need to dodge the cannon so\nthat it does not hit you, otherwise\nyou will lose, good luck!")
                .multilineTextAlignment(.center)
                .font(.custom("Rubik-Bold", size: 18))
                .foregroundColor(.white)
                .padding()
            
            Spacer()
        }
        .background(
            Image("game_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    GameRulesView()
        .environmentObject(UserData())
}
