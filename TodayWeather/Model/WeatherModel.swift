//
//  WeatherModel.swift
//  TodayWeather
//
//  Created by 이송은 on 2023/03/07.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let dataType: String
    let items: Items
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct Items: Codable {
    let item: [Item]
}

// MARK: - Item
struct Item: Codable {
    let tm, rnum, stnID: String
    let stnNm: StnNm
    let ta, taQcflg, rn, rnQcflg: String
    let ws, wsQcflg, wd, wdQcflg: String
    let hm, hmQcflg, pv, td: String
    let pa, paQcflg, ps, psQcflg: String
    let ss, ssQcflg, icsr, dsnw: String
    let hr3Fhsc, dc10Tca, dc10LmcsCA, clfmAbbrCD: String
    let lcsCh, vs, gndSttCD, dmstMtphNo: String
    let ts, tsQcflg, m005Te, m01Te: String
    let m02Te, m03Te: String

    enum CodingKeys: String, CodingKey {
        case tm, rnum
        case stnID = "stnId"
        case stnNm, ta, taQcflg, rn, rnQcflg, ws, wsQcflg, wd, wdQcflg, hm, hmQcflg, pv, td, pa, paQcflg, ps, psQcflg, ss, ssQcflg, icsr, dsnw, hr3Fhsc, dc10Tca
        case dc10LmcsCA = "dc10LmcsCa"
        case clfmAbbrCD = "clfmAbbrCd"
        case lcsCh, vs
        case gndSttCD = "gndSttCd"
        case dmstMtphNo, ts, tsQcflg, m005Te, m01Te, m02Te, m03Te
    }
}

enum StnNm: String, Codable {
    case 서울 = "서울"
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}
