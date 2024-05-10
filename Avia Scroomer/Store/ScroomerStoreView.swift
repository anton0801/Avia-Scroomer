import SwiftUI

struct ScroomerStoreView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var userData: UserData
    @StateObject var store: Store = Store()
    
    @State var buyStoreItemError = false
    
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
                ForEach(store.storeItems, id: \.id) { storeItem in
                    VStack {
                        VStack {
                            Image(storeItem.plane)
                                .resizable()
                                .frame(width: 50, height: 40)
                                .rotationEffect(.degrees(-90))
                        }
                        .frame(width: 80, height: 70)
                        .background(
                            Image("reward_bg")
                                .resizable()
                                .frame(width: 80, height: 70)
                        )
                        
                        VStack {
                            if userData.currentPlane == storeItem.plane {
                                Text("SELECTED")
                                    .multilineTextAlignment(.center)
                                    .font(.custom("Rubik-Bold", size: 14))
                                    .foregroundColor(.black)
                            } else {
                                if store.buiedPlanes.contains(where: { $0.id == storeItem.id }) {
                                    Button {
                                        userData.currentPlane = storeItem.plane
                                    } label: {
                                        Text("SELECT")
                                            .multilineTextAlignment(.center)
                                            .font(.custom("Rubik-Bold", size: 14))
                                            .foregroundColor(.black)
                                    }
                                } else {
                                    Button {
                                        buyStoreItemError = !store.buyStoreItem(userData: userData, storeItem: storeItem)
                                    } label: {
                                        Text("\(storeItem.price)")
                                            .multilineTextAlignment(.center)
                                            .font(.custom("Rubik-Bold", size: 14))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        .frame(width: 80, height: 30)
                        .background(
                            Image("reward_btn_bg")
                                .resizable()
                                .frame(width: 80, height: 30)
                        )
                    }
                }
            }
            
            Spacer()
        }
        .background(
            Image("game_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .alert(isPresented: $buyStoreItemError) {
            Alert(title: Text("Error buy plain!"),
                  message: Text("You don't have enough credits to purchase this airplane"),
                  dismissButton: .cancel(Text("OK")))
        }
    }
}

#Preview {
    ScroomerStoreView()
        .environmentObject(UserData())
}
