//
//  HomeViewDataManager.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/18.
//

import Foundation
import Combine

class HomeViewDataManager {

    let entireData = PassthroughSubject<HomeViewData, Never>()
    let recommendInfoData = PassthroughSubject<Products, Never>()

    private var cancellables = Set<AnyCancellable>()

    init() {
        self.getEntiredData()
        self.getRecommendInfoData()
    }
}

private extension HomeViewDataManager {
    
    func getEntiredData() {
        guard let validURL = URL(string: URLValue.homeEntireData.getRawValue()) else { return }

        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = HTTPMethod.get.getRawValue()

        JSONConverter<HomeViewData>.getHomeData(url: urlRequest, handler: { homeData in
            self.entireData.send(homeData)
        })
    }

    func getRecommendInfoData() {
        guard let productInfo = URL(string: URLValue.recommendData.getRawValue() + Query.recommendInfo.getRawValue()) else { return }

        var productInfoRequest = URLRequest(url: productInfo)
        productInfoRequest.httpMethod = HTTPMethod.post.getRawValue()
        productInfoRequest.setValue(HTTPHeader.urlEncoded.getRawValue(), forHTTPHeaderField: "Content-Type")

        self.entireData
            .sink(receiveValue: { homeData in
                homeData.yourRecommand.products.forEach {
                    guard let data = self.setHttpBody(value: $0) else { return }
                    productInfoRequest.httpBody = data

                    JSONConverter<Products>.getHomeData(url: productInfoRequest, handler: { data in
                        self.recommendInfoData.send(data)
                    })
                }
            })
            .store(in: &cancellables)
    }
    
    func setHttpBody(value: Any) -> Data? {
        let infoParam: [String: Any] = [HTTPBody.recommendInfo.getRawValue(): value]

        let formDataString = (infoParam.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        })).joined()

        return formDataString.data(using: .utf8)
    }
}

extension HomeViewDataManager {

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"

        func getRawValue() -> String {
            return self.rawValue
        }
    }

    enum URLValue: String {
        case homeEntireData = "https://api.codesquad.kr/starbuckst"
        case recommendData = "https://www.starbucks.co.kr/menu"

        func getRawValue() -> String {
            return self.rawValue
        }
    }

    enum Query: String {
        case recommendInfo = "/productViewAjax.do"
        case recommendImage = "/productFileAjax.do"

        func getRawValue() -> String {
            return self.rawValue
        }
    }

    enum HTTPHeader: String {
        case urlEncoded = "application/x-www-form-urlencoded; charset=utf-8"

        func getRawValue() -> String {
            return self.rawValue
        }
    }

    enum HTTPBody: String {
        case recommendInfo = "product_cd"
        case recommendImage = "PRODUCT_CD"

        func getRawValue() -> String {
            return self.rawValue
        }
    }

}
