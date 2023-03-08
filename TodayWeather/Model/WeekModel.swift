//
//  WeekModel.swift
//  TodayWeather
//
//  Created by 이송은 on 2023/03/08.
//

import Foundation

struct WeekModel{
    var week : [Items]
}

struct DayModel{
    var day : [WeekModel] // size of day = 7
}

struct MonthModel{
    
}
