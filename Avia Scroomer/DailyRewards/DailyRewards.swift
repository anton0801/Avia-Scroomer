import Foundation

struct DailyRewardModel: Identifiable {
    let id: String
    let name: String
    let reward: Int
}

class DailyRewards: ObservableObject {
    
    let allDailyRewards = [
        DailyRewardModel(id: "day_1", name: "1", reward: 1000),
        DailyRewardModel(id: "day_2", name: "2", reward: 2000),
        DailyRewardModel(id: "day_3", name: "3", reward: 3000),
        DailyRewardModel(id: "day_4", name: "4", reward: 4000),
        DailyRewardModel(id: "day_5", name: "5", reward: 5000),
        DailyRewardModel(id: "day_6", name: "6", reward: 6000),
        DailyRewardModel(id: "day_7", name: "7", reward: 7000),
        DailyRewardModel(id: "day_8", name: "8", reward: 8000),
        DailyRewardModel(id: "day_9", name: "9", reward: 9000)
    ]
    
    @Published var dailyRewardsAvailable: [DailyRewardModel] = []
    @Published var dailyRewardsClaimed: [DailyRewardModel] = []
 
    init() {
        initDailyRewards()
    }
    
    private func initDailyRewards() {
        let dailyRewardsClaimedComponentsSaved = UserDefaults.standard.string(forKey: "daily_rewards_claimed")?.components(separatedBy: ",") ?? []
        for reward in dailyRewardsClaimedComponentsSaved {
            dailyRewardsClaimed.append(allDailyRewards.filter { $0.id == reward }[0])
        }
        
        var rewardsDiff = [DailyRewardModel]()
        for reward in allDailyRewards {
            if dailyRewardsClaimed.contains(where: { $0.id == reward.id }) == false {
                rewardsDiff.append(reward)
            }
        }
        dailyRewardsAvailable = rewardsDiff
    }
    
    func canClaimReward() -> Bool {
        let savedDate = UserDefaults.standard.object(forKey: "lastClaimedDate") as? Date
        guard let claimedDate = savedDate else {
            return true
        }
        return Date().timeIntervalSince(claimedDate) >= 24 * 60 * 60
    }
        
    func claimReward(reward: DailyRewardModel) -> Bool {
        if dailyRewardsAvailable[0].id == reward.id {
            if canClaimReward() {
                dailyRewardsClaimed.append(reward)
                UserDefaults.standard.set(dailyRewardsClaimed.map({ $0.id }).joined(separator: ","), forKey: "daily_rewards_claimed")
                return true
            }
            return false
        }
        return false
    }
    
}
