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
    var max : Double?
    var min : Double?
    
    var dayModel = DayModel()
 
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var weekPicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        fetchData()
        
        
    }
    
 
    @IBAction func weekPicker(_ sender: Any) {
        startDate = ""
        endDate = ""
    }
    
    func calculateExtreme(){
        var Temparature : [String] = []
        for i in 0 ... ((Model?.response.body.totalCount ?? 20) - 1 ) {
            Temparature.append(Model?.response.body.items.item[i].ta ?? "")
        }
        var intTemp : [Double] = Temparature.map{ Double($0) ?? 0 }
        intTemp.sort()
        min = intTemp.first
        max = intTemp.last
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    func fetchData(){
        let urlString = address + "?ServiceKey=" + serviceKey + "&dataCd=ASOS&dateCd=HR&startDt=" + startDate + "&startHh=" + startHour + "&endDt=" + endDate + "&endHh=" + endHour + "&stnIds=" + stationID + "&dataType=" + dataType + "&numOfRows=" + numberOfRows
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            do{
                
                let weatherModel = try JSONDecoder().decode(WeatherModel.self, from: data)
                self.Model = weatherModel
                for i in 0 ... ((self.Model?.response.body.totalCount ?? 48) - 1) {
                    self.dayModel.temparatureArray.append(self.Model?.response.body.items.item[i].ta ?? "1")
                }
                self.calculateExtreme()
                print("day model : ",self.dayModel.temparatureArray)
                
            }catch{
                print(error)
            }
        }.resume()
    }
    
}

extension WeekViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekCell", for: indexPath) as? WeekCell else {return UITableViewCell()}
        
        cell.date.text = startDate
        cell.HighTA.text = max?.description
        cell.LowTA.text = min?.description
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
