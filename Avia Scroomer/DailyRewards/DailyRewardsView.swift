import SwiftUI

struct DailyRewardsView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var userData: UserData
    @StateObject var dailyRewards = DailyRewards()
    
    @State var dailyRewardClaimError = false
    
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
            
            LazyVGrid(columns: [
                GridItem(.flexible(minimum: 100), spacing: 0),
                GridItem(.flexible(minimum: 100), spacing: 0),
                GridItem(.flexible(minimum: 100), spacing: 0)
            ]) {
                ForEach(dailyRewards.allDailyRewards, id: \.id) { dailyReward in
                    VStack {
                        VStack {
                            Spacer()
                            Text("\(dailyReward.name)")
                                 .font(.custom("Rubik-Bold", size: 18))
                                 .foregroundColor(.black)
                            Spacer()
                            Text("\(dailyReward.reward)")
                                  .font(.custom("Rubik-Bold", size: 18))
                                  .foregroundColor(.black)
                            Spacer()
                        }
                        .frame(width: 80, height: 70)
                        .background(
                            Image("reward_bg")
                                .resizable()
                                .frame(width: 80, height: 70)
                        )
                        
                        Spacer().frame(height: 2)
                        
                        VStack {
                            if dailyRewards.dailyRewardsClaimed.contains(where: { $0.id == dailyReward.id }) {
                                Text("CLAIMED")
                                    .font(.custom("Rubik-Bold", size: 14))
                                    .foregroundColor(.black)
                            } else if dailyRewards.dailyRewardsAvailable[0].id == dailyReward.id {
                                Button {
                                    if dailyRewards.canClaimReward() {
                                        userData.credits += dailyReward.reward
                                    }
                                    dailyRewardClaimError = !dailyRewards.claimReward(reward: dailyReward)
                                } label: {
                                    Text("CLAIM")
                                        .font(.custom("Rubik-Bold", size: 14))
                                        .foregroundColor(.black)
                                }
                            } else {
                                Text("NOT\nAVAILABLE")
                                    .multilineTextAlignment(.center)
                                    .font(.custom("Rubik-Bold", size: 10))
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(width: 80, height: 30)
                        .background(
                            Image("reward_btn_bg")
                                .resizable()
                                .frame(width: 80, height: 30)
                        )
                    }
                    .padding(6)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 42, bottom: 0, trailing: 42))
            
            Spacer()
        }
        .background(
            Image("game_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .alert(isPresented: $dailyRewardClaimError) {
            Alert(title: Text("Error claim reward!"),
                  message: Text("While this reward is not available, come back the next day!"),
                  dismissButton: .cancel(Text("OK")))
        }
    }
}

#Preview {
    DailyRewardsView()
        .environmentObject(UserData())
}
