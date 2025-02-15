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
    let recommandReload = PassthroughSubject<Bool, Never>()
    let mainEventReload = PassthroughSubject<Data, Never>()
    let subEventReload = PassthroughSubject<(String, Data), Never>()

    private(set) var yourProductsSerial = [String]()
    private(set) var yourRecommandInfo = [String: String]()
    private(set) var yourRecommandImage = [String: Data]()

    private(set) var nowProductSerial = [String]()
    private(set) var nowRecommandInfo = [String: String]()
    private(set) var nowRecommandImage = [String: Data]()

    private var cancellables = Set<AnyCancellable>()

    init() {
        self.getEntiredData()
        self.getYourRecommand()
        self.getMainEvent()
        self.getSubEvents()
        self.getNowRecommand()
    }

    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
}

// MARK: Get data

private extension HomeViewDataManager {

    func getEntiredData() {
        guard let validURL = URL(string: URLValue.homeEntireData.getRawValue()) else { return }

        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = HTTPMethod.get.getRawValue()

        JSONConverter<HomeViewData>.getHomeData(url: urlRequest, handler: { homeData in
            self.yourProductsSerial.append(contentsOf: homeData.yourRecommand.products)
            self.nowProductSerial.append(contentsOf: homeData.nowRecommand.products)
            self.entireData.send(homeData)
        })
    }

    func getYourRecommand() {
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
                            self.yourRecommandInfo[productNumber] = name
                            self.recommandReload.send(true)
                        } else {
                            guard let index = self.yourProductsSerial.firstIndex(of: productNumber) else { return }
                            self.yourProductsSerial.remove(at: index)
                        }
                    })

                    JSONConverter<RecommandProductImage>.getHomeData(url: productImageRequest, handler: { data in
                        if let url = data.file?.first?.imageUrl {
                            self.makeDataImage(url: url, handler: { data in
                                self.yourRecommandImage[productNumber] = data
                                self.recommandReload.send(true)
                            })
                        } else {
                            guard let index = self.yourProductsSerial.firstIndex(of: productNumber) else { return }
                            self.yourProductsSerial.remove(at: index)
                        }
                    })
                }
            })
            .store(in: &cancellables)
    }

    func getMainEvent() {
        self.entireData
            .sink(receiveValue: { homeData in
                guard let imgURL = URL(string: "\(homeData.mainEvent.imgUPLOADPATH)\(homeData.mainEvent.mobTHUM)") else { return }

                self.makeDataImage(url: imgURL, handler: { data in
                    self.mainEventReload.send(data)
                })
            })
            .store(in: &cancellables)
    }

    func getSubEvents() {
        guard let mainEvent = URL(string: URLValue.mainEventData.getRawValue() + Query.mainEventList.getRawValue()) else { return }

        let method = HTTPMethod.post.getRawValue()
        let encode = HTTPHeader.urlEncoded.getRawValue()

        var subEventsRequest = URLRequest(url: mainEvent)
        subEventsRequest.httpMethod = method
        subEventsRequest.setValue(encode, forHTTPHeaderField: "Content-Type")
        subEventsRequest.httpBody = self.setHttpBody(value: "all", body: .mainEvent)

        self.entireData
            .sink(receiveValue: { _ in
                JSONConverter<SubEvents>.getHomeData(url: subEventsRequest, handler: { data in
                    data.list.forEach { subEvent in
                        let imgURL = subEvent.imageUploadPath.appendingPathComponent("/upload/promotion/").appendingPathComponent(subEvent.thumbnail)
                        self.makeDataImage(url: imgURL, handler: { data in
                            self.subEventReload.send((subEvent.title, data))
                        })
                    }
                })
            })
            .store(in: &cancellables)
    }

    func getNowRecommand() {
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
                homeData.nowRecommand.products.forEach { productNumber in
                    guard let infoData = self.setHttpBody(value: productNumber, body: .recommendInfo), let imageData = self.setHttpBody(value: productNumber, body: .recommendImage) else { return }
                    productInfoRequest.httpBody = infoData
                    productImageRequest.httpBody = imageData

                    JSONConverter<RecommandProductName>.getHomeData(url: productInfoRequest, handler: { data in
                        if let name = data.view?.productName {
                            self.nowRecommandInfo[productNumber] = name
                            self.recommandReload.send(false)
                        } else {
                            guard let index = self.nowProductSerial.firstIndex(of: productNumber) else { return }
                            self.nowProductSerial.remove(at: index)
                        }
                    })

                    JSONConverter<RecommandProductImage>.getHomeData(url: productImageRequest, handler: { data in
                        if let url = data.file?.first?.imageUrl {
                            self.makeDataImage(url: url, handler: { data in
                                self.nowRecommandImage[productNumber] = data
                                self.recommandReload.send(false)
                            })
                        } else {
                            guard let index = self.nowProductSerial.firstIndex(of: productNumber) else { return }
                            self.nowProductSerial.remove(at: index)
                        }
                    })
                }
            })
            .store(in: &cancellables)
    }
}

// MARK: Inner using function

private extension HomeViewDataManager {
    func setHttpBody(value: Any, body: HTTPBody) -> Data? {
        let infoParam: [String: Any] = [body.getRawValue(): value]

        let formDataString = (infoParam.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        })).joined()

        return formDataString.data(using: .utf8)
    }

    func makeDataImage(url: URL, handler: @escaping (Data) -> Void) {

        if let cachedImage = ImageCacheManager.loadCachedImage(url: url) { handler(cachedImage) }

        let imageRequest = URLRequest(url: url)
        URLConnector.getRequest(imageRequest)
            .sink { error in
                print(error)
            } receiveValue: { data in
                ImageCacheManager.shared.setObject(NSData(data: data), forKey: url.lastPathComponent as NSString)
                if let filePath = ImageCacheManager.path {
                FileManager().createFile(atPath: filePath, contents: data, attributes: nil)
                    handler(data)
                }
            }
            .store(in: &cancellables)
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
        case mainEventData = "https://www.starbucks.co.kr/whats_new"

        func getRawValue() -> String {
            return self.rawValue
        }
    }

    enum Query: String {
        case recommendInfo = "/productViewAjax.do"
        case recommendImage = "/productFileAjax.do"
        case mainEventList = "/getIngList.do"

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
        case mainEvent = "MENU_CD"

        func getRawValue() -> String {
            return self.rawValue
        }
    }

}
