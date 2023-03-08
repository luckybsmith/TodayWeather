//
//  WeekModel.swift
//  TodayWeather
//
//  Created by 이송은 on 2023/03/08.
//

import Foundation

/// 일 별 데이터
class DayModel{
    var week : [Item] = []
    var highTA : Double = 0.0
    var lowTA : Double = 0.0
    var date : String = ""
    var temparatureArray : [String] = []
}

/*
 temparaturearray를 24개 단위로 쪼개서 구조체로 만들고
 구조체 안 내용물은 최고기온 최저기온 날짜
 + 알파로 시간별 기온
 물론 시간별 기온으로 최고최저점 기온을 산출하는 거지만...
 */
