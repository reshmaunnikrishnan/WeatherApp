//
//  Weather.swift
//  WeatherApp
//
//  Created by Reshma Unnikrishnan on 21.08.19.
//  Copyright © 2019 ruvlmoon. All rights reserved.
//

import Foundation

public struct CurrentWeather: Decodable {
    
    let main : Main?
    let id : Int?
    let coord : Coord?
    let weather : [Weather]?
    let wind : Wind?
    let visibility : Int?
    let dt : Int?
    let base : String?
    let cod : Int?
    let name : String?
    let timezone : Int?
    let clouds : Clouds?
    
    enum CodingKeys: String, CodingKey {
        case main = "main"
        case id = "id"
        case coord = "coord"
        case weather = "weather"
        case wind = "wind"
        case visibility = "visibility"
        case dt = "dt"
        case base = "base"
        case cod = "cod"
        case name = "name"
        case timezone = "timezone"
        case sys = "sys"
        case clouds = "clouds"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        main = try values.decodeIfPresent(Main.self, forKey: .main)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        coord = try values.decodeIfPresent(Coord.self, forKey: .coord)
        weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
        wind = try values.decodeIfPresent(Wind.self, forKey: .wind)
        visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
        dt = try values.decodeIfPresent(Int.self, forKey: .dt)
        base = try values.decodeIfPresent(String.self, forKey: .base)
        cod = try values.decodeIfPresent(Int.self, forKey: .cod)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        timezone = try values.decodeIfPresent(Int.self, forKey: .timezone)
        clouds = try values.decodeIfPresent(Clouds.self, forKey: .clouds)
    }

}

struct Coord : Decodable {
    let lon: Double?
    let lat: Double?
    
    enum CodingKeys: String, CodingKey {
        case lon = "lon"
        case lat = "lat"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lon = try values.decodeIfPresent(Double.self, forKey: .lon)
    }
}

struct Wind: Decodable {
    let speed: Double?
    let deg: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        speed = try values.decodeIfPresent(Double.self, forKey: .speed)
        deg = try values.decodeIfPresent(Double.self, forKey: .deg)
    }
}

struct Clouds: Decodable {
    let all: Int?
    
    enum CodingKeys: String, CodingKey {
        case all = "all"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        all = try values.decodeIfPresent(Int.self, forKey: .all)
    }
}

struct Main: Decodable {
    let temp: Double?
    let pressure: Int?
    let humidity: Int?
    let temp_min: Double?
    let temp_max: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
        case temp_min = "temp_min"
        case temp_max = "temp_max"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
        pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
        temp_max = try values.decodeIfPresent(Double.self, forKey: .temp_max)
        temp = try values.decodeIfPresent(Double.self, forKey: .temp)
        temp_min = try values.decodeIfPresent(Double.self, forKey: .temp_min)
    }
}

struct Weather: Decodable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }
}
