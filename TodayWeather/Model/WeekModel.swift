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
    var highTA : String = ""
    var lowTA : String = ""
    var date : String = ""
    var temparatureArray : [String] = []
 
    var dateArr : [String] = []
    //24시간을 하나씩 묶은 것
    var DayArray : [String] = []
    
    func calculateMin(arr : [Double]) -> Double{
        var temp : [Double] = []
        temp = arr
        temp.sort()
        let arrMin = temp.first
        
        return arrMin ?? 0.0
    }
    
    func calculateMax(arr : [Double]) -> Double{
        var temp : [Double] = []
        temp = arr
        temp.sort()
        let arrMax = temp.last
        
        return arrMax ?? 0.0
    }
    
    
    func forMatter(arr : [String]) -> [Double] {
        let temp = arr.map{ Double($0) ?? 0.0}
        return temp
    }
    
    func transformToWeek(arr : [Double]) -> [[Double]]{
        var dayArr : [[Double]] = []
        
        let firstArr = Array(arr[0...23])
        let secondArr = Array(arr[24...47])
        let thirdArr = Array(arr[48...71])
        let fourthArr = Array(arr[72...95])
        let fifthArr = Array(arr[96...119])
        let sixthArr = Array(arr[120...143])
        let seventhArr = Array(arr[144...167])
        
        dayArr.append(firstArr)
        dayArr.append(secondArr)
        dayArr.append(thirdArr)
        dayArr.append(fourthArr)
        dayArr.append(fifthArr)
        dayArr.append(sixthArr)
        dayArr.append(seventhArr)
        /*
         for i in 0 ... arr.count - 1 {
         var subarr = Array(arr[0...23])
         first.append(subarr)
         }
         */
        return dayArr
    }
    
    
    /// 이차원 배열에서 데이터 끄집어내서 일당 최저최고기온구하깅
    func calculateDayMin(arr : [[Double]]) -> [Double] {
        var result : [Double] = []
        for i in 0 ... arr.count - 1 {
            result.append(calculateMin(arr: arr[i]))
        }
        return result
    }
    
    func calculateDayMax(arr : [[Double]]) -> [Double] {
        var result : [Double] = []
        for i in 0 ... arr.count - 1 {
            result.append(calculateMax(arr: arr[i]))
        }
        return result
    }
    
    func dateFormmater (str : String) -> String {
        
        return ""
    }
}
/*
 temparaturearray를 24개 단위로 쪼개서 구조체로 만들고
 구조체 안 내용물은 최고기온 최저기온 날짜
 + 알파로 시간별 기온
 물론 시간별 기온으로 최고최저점 기온을 산출하는 거지만...
 */
