//
//  StationEntity.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import CoreData

@objc(StationEntity)
final class StationEntity: NSManagedObject {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<StationEntity> {
        NSFetchRequest<StationEntity>(entityName: "StationEntity")
    }
    
    @NSManaged var id: String
    @NSManaged var address: String
    @NSManaged var coordinatesLat: NSNumber?
    @NSManaged var coordinatesLon: NSNumber?
    @NSManaged var openingTimes: String?
    @NSManaged var hotlinePhoneNumber: String?
    @NSManaged var lastUpdate: String
    @NSManaged var image: String?
    @NSManaged var chargingPower: NSNumber?
    @NSManaged var chargingPowerDesc: String?
    @NSManaged var stationName: String
    
    convenience init(item: StationDTO) {
        self.init(context: AppPreferences.shared.storage.context)
        
        self.id = item.id
        self.address = item.address
        self.coordinatesLat = (Double(item.coordinates?.latitude ?? 0.0)) as NSNumber
        self.coordinatesLon = (Double(item.coordinates?.longitude ?? 0.0)) as NSNumber
        self.openingTimes = item.openingHours
        self.hotlinePhoneNumber = item.hotlinPhoneNumber
        self.lastUpdate = item.lastUpdate
        self.image = item.image
        self.chargingPower = NSNumber(floatLiteral: item.chargingPower?.input ?? 0.0)
        self.chargingPowerDesc = item.chargingPower?.description
        self.stationName = item.stationName
    }
}

extension StationEntity: Storagable {}

extension StationEntity : Identifiable {
    public static func == (lhs: StationEntity, rhs: StationEntity) -> Bool {
        lhs.id == rhs.id
    }
}

