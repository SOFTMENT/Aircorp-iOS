//
//  WeatherModel.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 31/01/24.
//

import Foundation

// MARK: - WeatherModel
class WeatherModel: Codable {
    var location: Location?
    var current: Current?

    init(location: Location?, current: Current?) {
        self.location = location
        self.current = current
    }
}

// MARK: - Current
class Current: Codable {
    var lastUpdatedEpoch: Int?
    var lastUpdated: String?
    var tempC: Int?
    var tempF: Double?
    var isDay: Int?
    var condition: Condition?
    var windMph, windKph: Double?
    var windDegree: Int?
    var windDir: String?
    var pressureMB: Int?
    var pressureIn: Double?
    var precipMm, precipIn, humidity, cloud: Int?
    var feelslikeC, feelslikeF, visKM: Double?
    var visMiles, uv: Int?
    var gustMph, gustKph: Double?

    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMB = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case visKM = "vis_km"
        case visMiles = "vis_miles"
        case uv
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
    }

    init(lastUpdatedEpoch: Int?, lastUpdated: String?, tempC: Int?, tempF: Double?, isDay: Int?, condition: Condition?, windMph: Double?, windKph: Double?, windDegree: Int?, windDir: String?, pressureMB: Int?, pressureIn: Double?, precipMm: Int?, precipIn: Int?, humidity: Int?, cloud: Int?, feelslikeC: Double?, feelslikeF: Double?, visKM: Double?, visMiles: Int?, uv: Int?, gustMph: Double?, gustKph: Double?) {
        self.lastUpdatedEpoch = lastUpdatedEpoch
        self.lastUpdated = lastUpdated
        self.tempC = tempC
        self.tempF = tempF
        self.isDay = isDay
        self.condition = condition
        self.windMph = windMph
        self.windKph = windKph
        self.windDegree = windDegree
        self.windDir = windDir
        self.pressureMB = pressureMB
        self.pressureIn = pressureIn
        self.precipMm = precipMm
        self.precipIn = precipIn
        self.humidity = humidity
        self.cloud = cloud
        self.feelslikeC = feelslikeC
        self.feelslikeF = feelslikeF
        self.visKM = visKM
        self.visMiles = visMiles
        self.uv = uv
        self.gustMph = gustMph
        self.gustKph = gustKph
    }
}

// MARK: - Condition
class Condition: Codable {
    var text, icon: String?
    var code: Int?

    init(text: String?, icon: String?, code: Int?) {
        self.text = text
        self.icon = icon
        self.code = code
    }
}

// MARK: - Location
class Location: Codable {
    var name, region, country: String?
    var lat, lon: Double?
    var tzID: String?
    var localtimeEpoch: Int?
    var localtime: String?

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }

    init(name: String?, region: String?, country: String?, lat: Double?, lon: Double?, tzID: String?, localtimeEpoch: Int?, localtime: String?) {
        self.name = name
        self.region = region
        self.country = country
        self.lat = lat
        self.lon = lon
        self.tzID = tzID
        self.localtimeEpoch = localtimeEpoch
        self.localtime = localtime
    }
}
