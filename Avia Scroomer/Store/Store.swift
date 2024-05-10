import Foundation

struct StoreItem {
    let id: String
    let plane: String
    let price: Int
}

class Store: ObservableObject {
    
    var storeItems = [
        StoreItem(id: "plane_1", plane: "plane", price: -1),
        StoreItem(id: "plane_2", plane: "plane_2", price: 2500),
        StoreItem(id: "plane_3", plane: "plane_3", price: 5500),
        StoreItem(id: "plane_4", plane: "plane_4", price: 7500),
        StoreItem(id: "plane_5", plane: "plane_5", price: 8500),
        StoreItem(id: "plane_6", plane: "plane_6", price: 9500),
        StoreItem(id: "plane_7", plane: "plane_7", price: 11500),
        StoreItem(id: "plane_8", plane: "plane_8", price: 1500),
        StoreItem(id: "plane_9", plane: "plane_9", price: 12500)
    ]
    
    @Published var buiedPlanes: [StoreItem] = []
    
    init() {
        initStoreItems()
    }
    
    private func initStoreItems() {
        let savedBuiedPlanes = UserDefaults.standard.string(forKey: "buied_store_items")?.components(separatedBy: ",") ?? []
        for plane in savedBuiedPlanes {
            buiedPlanes.append(storeItems.filter { $0.id == plane }[0])
        }
        if buiedPlanes.isEmpty {
            buiedPlanes.append(storeItems[0])
        }
    }
    
    func buyStoreItem(userData: UserData, storeItem: StoreItem) -> Bool {
        if userData.credits >= storeItem.price {
            buiedPlanes.append(storeItem)
            UserDefaults.standard.set(buiedPlanes.map { $0.id }.joined(separator: ","), forKey: "buied_store_items")
            userData.credits -= storeItem.price
            return true
        }
        return false
    }
    
}
