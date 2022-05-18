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
    let recommendReload = PassthroughSubject<Bool, Never>()

    private(set) var yourProductsSerial = [String]()
    private(set) var recommandInfo = [String: String]()
    private(set) var recommandImage = [String: Data]()

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
            self.yourProductsSerial.append(contentsOf: homeData.yourRecommand.products)
            self.entireData.send(homeData)
        })
    }

    func getRecommendInfoData() {
        guard let productInfo = URL(string: URLValue.recommendData.getRawValue() + Query.recommendInfo.getRawValue()), let productImage = URL(string: URLValue.recommendData.getRawValue() + Query.recommendImage.getRawValue()) else { return }

        let method = HTTPMethod.post.getRawValue()
        let encode = HTTPHeader.urlEncoded.getRawValue()

        var productInfoRequest = URLRequest(url: productInfo)
        productInfoRequest.httpMethod = method
        productInfoRequest.setValue(encode, forHTTPHeaderField: "Content-Type")

        var productImageRequest = URLRequest(url: productImage)
        productImageRequest.httpMethod = method
        productImageRequest.setValue(encode, forHTTPHeaderField: "Content-Type")

        self.entireData
            .sink(receiveValue: { homeData in
                homeData.yourRecommand.products.forEach { productNumber in
                    guard let infoData = self.setHttpBody(value: productNumber, body: .recommendInfo), let imageData = self.setHttpBody(value: productNumber, body: .recommendImage) else { return }
                    productInfoRequest.httpBody = infoData
                    productImageRequest.httpBody = imageData

                    JSONConverter<RecommandProductName>.getHomeData(url: productInfoRequest, handler: { data in
                        if let name = data.view?.productName {
                            self.recommandInfo[productNumber] = name
                            self.recommendReload.send(true)
                        } else {
                            guard let index = self.yourProductsSerial.firstIndex(of: productNumber) else { return }
                            self.yourProductsSerial.remove(at: index)
                        }
                    })

                    JSONConverter<RecommandProductImage>.getHomeData(url: productImageRequest, handler: { data in
                        if let url = data.file?.first?.imageUrl {
                            guard let imgData = self.makeDataImage(url: url) else { return }
                            self.recommandImage[productNumber] = imgData
                            self.recommendReload.send(true)
                        } else {
                            guard let index = self.yourProductsSerial.firstIndex(of: productNumber) else { return }
                            self.yourProductsSerial.remove(at: index)
                        }
                    })
                }
            })
            .store(in: &cancellables)
    }

    func setHttpBody(value: Any, body: HTTPBody) -> Data? {
        let infoParam: [String: Any] = [body.getRawValue(): value]

        let formDataString = (infoParam.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        })).joined()

        return formDataString.data(using: .utf8)
    }

    func makeDataImage(url: URL) -> Data? {
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
           return nil
        }
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
