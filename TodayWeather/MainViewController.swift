//
//  ViewController.swift
//  TodayWeather
//
//  Created by 이송은 on 2023/03/07.
//

import UIKit

class MainViewController: UIViewController {

    let address = "http://apis.data.go.kr/1360000/AsosHourlyInfoService/getWthrDataList"
    let serviceKey = "l79sCDEpQs9s9WUwjOr%2FmUBwcmjKYrQdvNl57pXJtJF%2BIm8fxLP2iJCRNjpvecZmjQrn0yaMIO1c0XGl9hIGKg%3D%3D"
    var startDate  = "20220101"
    var startHour  = "00"
    var endDate  = "20220101"
    var endHour  = "23"
    var stationID  = "108" // seoul
    var dataType = "JSON"
    var numberOfRows = "24"
    var Model : WeatherModel?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        tableView.delegate = self
        tableView.dataSource = self
        
        print(datePicker.date)
        datePicker.maximumDate = .now
        
    }

    func fetchData(){
        let urlString = address + "?ServiceKey=" + serviceKey + "&dataCd=ASOS&dateCd=HR&startDt=" + startDate + "&startHh=" + startHour + "&endDt=" + endDate + "&endHh=" + endHour + "&stnIds=" + stationID + "&dataType=" + dataType + "&numOfRows=" + numberOfRows
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            do{
                let weatherModel = try JSONDecoder().decode(WeatherModel.self, from: data)
                self.Model = weatherModel
                let stationName = weatherModel.response.body.items.item[0].stnNm
                DispatchQueue.main.async {
                    self.stationNameLabel.text = stationName.rawValue
                    self.tableView.reloadData()
                }
            }catch{
                print(error)
            }
        }.resume()
    }
    
    
    @IBAction func TouchPicker(_ sender: Any) {
        
        let date = self.datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        let dateString = dateFormatter.string(from: date)
        startDate = dateString
        endDate = dateString
        fetchData()
        self.tableView.reloadData()
    }
    
    
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model?.response.body.items.item.count ?? 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell else { return  UITableViewCell() }
        cell.timeLabel.text = self.Model?.response.body.items.item[indexPath.row].tm
        cell.temparatureLabel.text = self.Model?.response.body.items.item[indexPath.row].ta
        
//        cell.timeLabel.text =  indexPath.row.description
//        cell.temparatureLabel.text = indexPath.description
        return cell
    }
    
    
}

class WeatherCell : UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temparatureLabel: UILabel!
    /*
    let time : String?
    let temparature : String?
    let stationName : String?
    let date : String?
     */
}
