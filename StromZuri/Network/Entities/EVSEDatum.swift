//
//  EVSEDatum.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 28/01/24.
//

import Foundation

// MARK: - EVSEResponse
struct EVSEResponse: Codable {
    let evseData: [EVSEDatum]

    enum CodingKeys: String, CodingKey {
        case evseData = "EVSEData"
    }
}

// MARK: - EVSEDatum
struct EVSEDatum: Codable {
    let evseDataRecord: [EVSEDataRecord]
    let operatorID, operatorName: String

    enum CodingKeys: String, CodingKey {
        case evseDataRecord = "EVSEDataRecord"
        case operatorID = "OperatorID"
        case operatorName = "OperatorName"
    }
}

// MARK: - EVSEDataRecord
struct EVSEDataRecord: Codable {
    let accessibilityLocation: AccessibilityLocation?
    let address: Address
    let authenticationModes: [AuthenticationMode]
    let calibrationLawDataAvailability: CalibrationLawDataAvailability
    let chargingFacilities: [ChargingFacility]
    let chargingStationNames: ChargingStationNames
    let dynamicInfoAvailable, hotlinePhoneNumber: String
    let hubOperatorID: HubOperatorID?
    let isHubjectCompatible, isOpen24Hours: Bool
    let paymentOptions: [PaymentOption]?
    let plugs: [Plug]
    let renewableEnergy: Bool
    let valueAddedServices: [ValueAddedService]?
    let deltaType: DeltaType?
    let accessibility: Accessibility
    let chargingStationID: String
    let geoCoordinates: GeoC
    let lastUpdate: String?
    let evseID: String
    let clearinghouseID: JSONNull?
    let openingTimes: [OpeningTime]?
    let geoChargingPointEntrance: GeoC
    let chargingStationLocationReference, energySource, environmentalImpact, locationImage: String? // JSONNull
    let suboperatorName: JSONNull?
    let maxCapacity: Int?
    let additionalInfo, chargingPoolID: JSONNull?
    let dynamicPowerLevel: Bool?
    let hardwareManufacturer: JSONNull?
    let subOperatorName: SubOperatorName?

    enum CodingKeys: String, CodingKey {
        case accessibilityLocation = "AccessibilityLocation"
        case address = "Address"
        case authenticationModes = "AuthenticationModes"
        case calibrationLawDataAvailability = "CalibrationLawDataAvailability"
        case chargingFacilities = "ChargingFacilities"
        case chargingStationNames = "ChargingStationNames"
        case dynamicInfoAvailable = "DynamicInfoAvailable"
        case hotlinePhoneNumber = "HotlinePhoneNumber"
        case hubOperatorID = "HubOperatorID"
        case isHubjectCompatible = "IsHubjectCompatible"
        case isOpen24Hours = "IsOpen24Hours"
        case paymentOptions = "PaymentOptions"
        case plugs = "Plugs"
        case renewableEnergy = "RenewableEnergy"
        case valueAddedServices = "ValueAddedServices"
        case deltaType
        case accessibility = "Accessibility"
        case chargingStationID = "ChargingStationId"
        case geoCoordinates = "GeoCoordinates"
        case lastUpdate
        case evseID = "EvseID"
        case clearinghouseID = "ClearinghouseID"
        case openingTimes = "OpeningTimes"
        case geoChargingPointEntrance = "GeoChargingPointEntrance"
        case chargingStationLocationReference = "ChargingStationLocationReference"
        case energySource = "EnergySource"
        case environmentalImpact = "EnvironmentalImpact"
        case locationImage = "LocationImage"
        case suboperatorName = "SuboperatorName"
        case maxCapacity = "MaxCapacity"
        case additionalInfo = "AdditionalInfo"
        case chargingPoolID = "ChargingPoolID"
        case dynamicPowerLevel = "DynamicPowerLevel"
        case hardwareManufacturer = "HardwareManufacturer"
        case subOperatorName = "SubOperatorName"
    }
    
    
    var isAvailable: Bool {
        guard let current = OpeningTime.getCurrentDateOpeningTime(from: self.openingTimes ?? []) else {
            return false
        }
        return OpeningTime.checkAvailability(for: current)
    }
}

extension EVSEDataRecord {
    func convert() -> StationDTO {
        .init(
            id: self.evseID,
            openingHours: {
                if self.isOpen24Hours {
                    return "Available - 24/7"
                } else {
                    return OpeningTime.getCurrentDateOpeningTime(from: self.openingTimes ?? [])?.description
                }
            }(),
            lastUpdate: self.lastUpdate ?? Date().timeIntervalSince1970.stringValue,
            address: self.address.toString(),
            coordinates: LocationCoordinatesAdapter.convert(self.geoCoordinates.google),
            hotlinPhoneNumber: self.hotlinePhoneNumber,
            image: self.locationImage,
            stationName: self.chargingStationNames.chargingStationNameForEn ?? "Station - ID: \(self.evseID)",
            chargingPower: {
                if let power = self.chargingFacilities.first?.power {
                    return .init(power: power)
                }
                return nil
            }()
        )
    }
}

enum Accessibility: String, Codable {
    case freePubliclyAccessible = "Free publicly accessible"
    case payingPubliclyAccessible = "Paying publicly accessible"
    case restrictedAccess = "Restricted access"
    case testStation = "Test Station"
    case unspecified = "Unspecified"
}

enum AccessibilityLocation: String, Codable {
    case onStreet = "OnStreet"
    case parkingGarage = "ParkingGarage"
    case parkingLot = "ParkingLot"
    case undergroundParkingGarage = "UndergroundParkingGarage"
}

// MARK: - Address
struct Address: Codable {
    let houseNum: String?
    let timeZone: TimeZone?
    let city: String
    let country: Country
    let postalCode: String?
    let street: String
    let floor: String?
    let region: Region?
    let parkingSpot: JSONNull?
    let parkingFacility: Bool?

    enum CodingKeys: String, CodingKey {
        case houseNum = "HouseNum"
        case timeZone = "TimeZone"
        case city = "City"
        case country = "Country"
        case postalCode = "PostalCode"
        case street = "Street"
        case floor = "Floor"
        case region = "Region"
        case parkingSpot = "ParkingSpot"
        case parkingFacility = "ParkingFacility"
    }
}

extension Address {
    func toString() -> String {
        var addressComponents: [String] = []

        if let houseNum = houseNum {
            addressComponents.append("House: \(houseNum)")
        }

        if let timeZone = timeZone {
            addressComponents.append("Time Zone: \(timeZone)")
        }

        addressComponents.append("City: \(city)")
        addressComponents.append("Country: \(country.rawValue)")

        if let postalCode = postalCode {
            addressComponents.append("Postal Code: \(postalCode)")
        }

        addressComponents.append("Street: \(street)")

        if let floor = floor {
            addressComponents.append("Floor: \(floor)")
        }

        if let region = region {
            addressComponents.append("Region: \(region.rawValue)")
        }

        if parkingSpot != nil {
            addressComponents.append("Parking Spot: [Null]")
        }

        if let parkingFacility = parkingFacility {
            addressComponents.append("Parking Facility: \(parkingFacility)")
        }

        return addressComponents.joined(separator: ", ")
    }
}

enum Country: String, Codable {
    case arg = "ARG"
    case aus = "AUS"
    case aut = "AUT"
    case bel = "BEL"
    case che = "CHE"
    case cyp = "CYP"
    case deu = "DEU"
    case est = "EST"
    case fin = "FIN"
    case fra = "FRA"
    case isr = "ISR"
    case ita = "ITA"
    case lao = "LAO"
    case lie = "LIE"
    case ltu = "LTU"
    case nld = "NLD"
    case pol = "POL"
    case svk = "SVK"
}

enum Region: String, Codable {
    case graubünden = "Graubünden"
    case mittelland = "Mittelland"
}

enum TimeZone: String, Codable {
    case utc0100 = "UTC+01:00"
    case utc0200 = "UTC+02:00"
}

enum AuthenticationMode: String, Codable {
    case directPayment = "Direct Payment"
    case nfcRFIDClassic = "NFC RFID Classic"
    case nfcRFIDDESFire = "NFC RFID DESFire"
    case pnC = "PnC"
    case remote = "REMOTE"
}

enum CalibrationLawDataAvailability: String, Codable {
    case notAvailable = "Not Available"
}

// MARK: - ChargingFacility
struct ChargingFacility: Codable {
    let power: Power
    let powertype: Powertype?
    let amperage, voltage: Age?

    enum CodingKeys: String, CodingKey {
        case power, powertype
        case amperage = "Amperage"
        case voltage = "Voltage"
    }
}

enum Age: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Age.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Age"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

enum Power: Codable {
    case double(Double)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Power.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Power"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
    
    var value: Double {
        switch self {
        case .double(let x):
            return x
        case .string(let x):
            return Double(x) ?? 0.0
        }
    }
    
    var description: String {
        switch self {
        case .double(let x):
            return x.stringValue
        case .string(let x):
            return x
        }
    }
}

enum Powertype: String, Codable {
    case ac1_Phase = "AC_1_PHASE"
    case ac3_Phase = "AC_3_PHASE"
    case dc = "DC"
}

enum ChargingStationNames: Codable {
    case chargingStationName(ChargingStationName)
    case chargingStationNameArray([ChargingStationName])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([ChargingStationName].self) {
            self = .chargingStationNameArray(x)
            return
        }
        if let x = try? container.decode(ChargingStationName.self) {
            self = .chargingStationName(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(ChargingStationNames.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ChargingStationNames"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .chargingStationName(let x):
            try container.encode(x)
        case .chargingStationNameArray(let x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        }
    }
    
    var chargingStationNameForEn: String? {
        switch self {
        case .chargingStationName(let chargingStationName):
            if chargingStationName.lang == .en {
                return chargingStationName.value
            } else {
                return nil
            }
        case .chargingStationNameArray(let chargingStationNameArray):
            let enName = chargingStationNameArray.first { $0.lang == .en }
            return enName?.value
        case .null:
            return nil
        }
    }
}

// MARK: - ChargingStationName
struct ChargingStationName: Codable {
    let lang: Lang
    let value: String
}

enum Lang: String, Codable {
    case de = "de"
    case en = "en"
    case fr = "fr"
    case it = "it"
}

enum DeltaType: String, Codable {
    case insert = "insert"
}

// MARK: - GeoC
struct GeoC: Codable {
    let google: String

    enum CodingKeys: String, CodingKey {
        case google = "Google"
    }
}

enum HubOperatorID: String, Codable {
    case chSwisscharge = "CH*SWISSCHARGE"
}

// MARK: - OpeningTime
struct OpeningTime: Codable {
    let period: [Period]
    let on: On

    enum CodingKeys: String, CodingKey {
        case period = "Period"
        case on
    }
    
    var description: String {
        return "\(on) - from \(String(describing: period.first?.begin.rawValue)) - to \(String(describing: period.last?.end.rawValue))"
    }
    
    static func checkAvailability(for openingTime: OpeningTime) -> Bool {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let currentDay = dateFormatter.string(from: currentDate)

        guard let dayEnum = On(rawValue: currentDay) else {
            return false
        }

        if let currentDayPeriod = openingTime.period.first, let currentDayEnd = openingTime.period.last {
            let currentTimeString = DateFormatter.localizedString(from: currentDate, dateStyle: .none, timeStyle: .short)
            let currentTime = Begin(rawValue: currentTimeString) ?? .the0000

            return currentTime.rawValue >= currentDayPeriod.begin.rawValue && currentTime.rawValue <= currentDayEnd.end.rawValue
        }

        return false
    }
    
    static func getCurrentDateOpeningTime(from openingTimes: [OpeningTime]) -> OpeningTime? {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let currentDay = dateFormatter.string(from: currentDate)

        guard let currentDayEnum = On(rawValue: currentDay) else {
            return nil
        }

        return openingTimes.first { openingTime in
            return openingTime.on == currentDayEnum
        }
    }
}

enum On: String, Codable {
    case friday = "Friday"
    case monday = "Monday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    case thursday = "Thursday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
}

// MARK: - Period
struct Period: Codable {
    let begin: Begin
    let end: End
}

enum Begin: String, Codable {
    case the0000 = "00:00"
    case the0520 = "05:20"
    case the0700 = "07:00"
    case the0800 = "08:00"
    case the0900 = "09:00"
    case the1000 = "10:00"
    case the1400 = "14:00"
    case the1800 = "18:00"
}

enum End: String, Codable {
    case the0600 = "06:00"
    case the1000 = "10:00"
    case the1600 = "16:00"
    case the1700 = "17:00"
    case the1730 = "17:30"
    case the1830 = "18:30"
    case the2000 = "20:00"
    case the2200 = "22:00"
    case the2350 = "23:50"
    case the2359 = "23:59"
}

enum PaymentOption: String, Codable {
    case contract = "Contract"
    case direct = "Direct"
    case noPayment = "No Payment"
}

enum Plug: String, Codable {
    case ccsCombo1PlugCableAttached = "CCS Combo 1 Plug (Cable Attached)"
    case ccsCombo2PlugCableAttached = "CCS Combo 2 Plug (Cable Attached)"
    case chAdeMO = "CHAdeMO"
    case teslaConnector = "Tesla Connector"
    case type1ConnectorCableAttached = "Type 1 Connector (Cable Attached)"
    case type2ConnectorCableAttached = "Type 2 Connector (Cable Attached)"
    case type2Outlet = "Type 2 Outlet"
    case typeFSchuko = "Type F Schuko"
    case typeJSwissStandard = "Type J Swiss Standard"
}

enum SubOperatorName: String, Codable {
    case chargePoint = "ChargePoint"
    case empty = ""
    case hotelSchaefliGmbH = "Hotel Schaefli GmbH"
    case shareBirrerAG = "Share Birrer AG"
    case wwzEnergieAG = "WWZ Energie AG"
}

enum ValueAddedService: String, Codable {
    case dynamicPricing = "DynamicPricing"
    case maximumPowerCharging = "MaximumPowerCharging"
    case none = "None"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    static func == (lhs: JSONNull, rhs: JSONNull) -> Bool { true }

    func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }

    init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
