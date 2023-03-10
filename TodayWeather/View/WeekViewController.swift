//
//  WeekViewController.swift
//  TodayWeather
//
//  Created by 이송은 on 2023/03/08.
//

import UIKit

class WeekViewController: UIViewController {
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
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var weekPicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        weekPicker.maximumDate = .now
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchData(startdate: Int(startDate) ?? 20220101)
        
    }
    
 
    @IBAction func weekPicker(_ sender: Any) {
       
         let date = self.weekPicker.date
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "YYYYMMdd"
         let dateString = dateFormatter.string(from: date)
        print(dateString)
        selectedDate = Int(dateString) ?? 0
        dateFormmater(selectedDate: selectedDate)
        tableView.reloadData()
     
        fetchData(startdate: selectedDate)
         
    }
    
    func calculateExtreme(){
        var Temparature : [String] = []
        for i in 0 ... ((Model?.response.body.totalCount ?? 20) - 1 ) {
            Temparature.append(Model?.response.body.items.item[i].ta ?? "")
        }
        var intTemp : [Double] = Temparature.map{ Double($0) ?? 0 }
        intTemp.sort()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    func dateFormmater (selectedDate : Int){
        selectedWeek = []
        for i in 0 ... 6 {
            selectedWeek.append(selectedDate + i)
        }
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
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            }catch{
                print(error)
            }
        }.resume()
    }
    
}

extension WeekViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.highTAarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekCell", for: indexPath) as? WeekCell else {return UITableViewCell()}
        
        cell.date.text = selectedWeek[indexPath.row].description
        cell.HighTA.text = highTAarr[indexPath.row].description
        cell.LowTA.text = lowTAarr[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

class WeekCell : UITableViewCell{
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var HighTA: UILabel!
    
    @IBOutlet weak var LowTA: UILabel!
}
