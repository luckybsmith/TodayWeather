//
//  NetworkModel.swift
//  TodayWeather
//
//  Created by 이송은 on 2023/03/08.
//

import Foundation

class NetworkModel {
    
    let address = "http://apis.data.go.kr/1360000/AsosHourlyInfoService/getWthrDataList"
    let serviceKey = "l79sCDEpQs9s9WUwjOr%2FmUBwcmjKYrQdvNl57pXJtJF%2BIm8fxLP2iJCRNjpvecZmjQrn0yaMIO1c0XGl9hIGKg%3D%3D"
    var startDate  = "20220101"
    var startHour  = "00"
    var endDate  = "20220107"
    var endHour  = "23"
    var stationID  = "108" // seoul
    var dataType = "JSON"
    var numberOfRows = "168"
    var Model : WeatherModel?
    var highTAarr : [Double] = []
    var lowTAarr : [Double] = []
    
    
    var selectedDate : Int = 0
    var selectedWeek : [Int] = [1,2,3,4,5,6,7]
    
    func calculateExtreme(){
        var Temparature : [String] = []
        for i in 0 ... ((Model?.response.body.totalCount ?? 20) - 1 ) {
            Temparature.append(Model?.response.body.items.item[i].ta ?? "")
        }
        var intTemp : [Double] = Temparature.map{ Double($0) ?? 0 }
        intTemp.sort()
    }
    
    func dateFormmater (selectedDate : Int){
        selectedWeek = []
        selectedWeek.append(selectedDate)
        selectedWeek.append(selectedDate + 1)
        selectedWeek.append(selectedDate + 2)
        selectedWeek.append(selectedDate + 3)
        selectedWeek.append(selectedDate + 4)
        selectedWeek.append(selectedDate + 5)
        selectedWeek.append(selectedDate + 6)
        
    }
    
    func fetchData(startdate : Int){
        
        var dayModel = DayModel()
        
        let urlString = address + "?ServiceKey=" + serviceKey + "&dataCd=ASOS&dateCd=HR&startDt=" + startdate.description + "&startHh=" + startHour + "&endDt=" + (startdate + 6).description + "&endHh=" + endHour + "&stnIds=" + stationID + "&dataType=" + dataType + "&numOfRows=" + numberOfRows
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            do{
                
                let weatherModel = try JSONDecoder().decode(WeatherModel.self, from: data)
                self.Model = weatherModel
                for i in 0 ... ((self.Model?.response.body.totalCount ?? 48) - 1) {
                    dayModel.temparatureArray.append(self.Model?.response.body.items.item[i].ta ?? "1")
                }
                self.calculateExtreme()
                let doubleArr = dayModel.forMatter(arr: dayModel.temparatureArray)
                
                let doubleDimensionArray = dayModel.transformToWeek(arr: doubleArr)
                //print("doubleDimensionArray : " , doubleDimensionArray)
                
                self.lowTAarr = dayModel.calculateDayMin(arr: doubleDimensionArray)
                self.highTAarr = dayModel.calculateDayMax(arr: doubleDimensionArray)
                
            }catch{
                print(error)
            }
        }.resume()
        
        
        
    }
        
}
