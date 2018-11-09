//
//  Api.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/09.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation

/// Api通信エラーコード
public enum ApiError: Int, Error {
    case recieveNilResponse = 0,    // レスポンスエラー
    recieveErrorHttpStatus,         // HTTPステータス
    recieveNilBody,                 // nilデータ
    failedParse                     // パースエラー
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

/// リクエスト情報プロトコル
public protocol RequestDto {

    var url: String { get }
    /// パラメータ配列取得
    /// - Returns: パラメータ配列 同じkey名で複数つける場合がある為、辞書型ではなく独自型配列としています
    func params() -> [(key: String, value: String)]
}

//APIリクエストプロトコル
protocol ApiProtocol {
    func request(_ httpMethod: HttpMethod, dto: RequestDto, onSuccess: @escaping (Data, URLResponse?) -> Void, onError: @escaping (Error) -> Void)
}

/// NSURLSessionTaskを作ってHTTP通信を行うクラスです。
/// RequestDtoでパラメータを指定し、受信後に指定parserでパースしてentityを返却します。
/// GETの場合はパラメータを指定URLに追加、POSTの場合はDataに変換しbodyに設定します。
/// POSTの場合にGET情報も付与したい場合は、URLにあらかじめ付与しておいて下さい。
open class ApiTask: ApiProtocol {

    // MARK: - PubricParams
    /// HTTPHeader[ヘッダフィールド名: 対応する値]を記述する。
    /// よく使う値をdefaultとしている為、不要な場合はnilで上書きして下さい。
    public var httpHeader: [String: String]? = ["content-type": "application/json"]
    /// timeoutの時間
    /// default: 60
    public var timeoutInterval: TimeInterval = 60
    /// キャッシュ設定
    /// default: reloadIgnoringLocalCacheData(使用しない)
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    /// 通信中のセッション
    static let apiTaskSession: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)

    public init() {}

    public func request(_ httpMethod: HttpMethod, dto: RequestDto, onSuccess: @escaping (Data, URLResponse?) -> Void, onError: @escaping (Error) -> Void) {
        let urlRequest = URLRequestCreator.create(httpMethod: httpMethod,
                                                 dto: dto,
                                                 header: httpHeader,
                                                 timeoutInterval: timeoutInterval,
                                                 cachePolicy: cachePolicy)
        let task = ApiTask.apiTaskSession.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            #if DEBUG
            // Warning: print is very slow speed so comment out default
            //self.debugResponse(with: urlRequest, data: data, response: response)
            #endif

            if let error = error {
                onError(error)
                return
            }
            if let responseError = ApiTask.check(response: response) {
                onError(responseError)
                return
            }
            guard let data = data else {
                onError(ApiError.recieveNilBody)
                return
            }
            onSuccess(data, response)
        })
        task.resume()
    }

    static func createError(_ code: ApiError, _ info: [String: Any]?) -> NSError {
        return NSError(domain: "ApiError", code: code.rawValue, userInfo: info)
    }

    static internal func check(response: URLResponse?) -> NSError? {
        guard let notNilResponse = response else {
            return createError(.recieveNilResponse, nil)
        }

        let httpResponse = notNilResponse as! HTTPURLResponse
        guard (200..<300) ~= httpResponse.statusCode else {
            return createError(.recieveErrorHttpStatus, ["statusCode": httpResponse.statusCode])
        }
        return nil
    }

    private func debugResponse(with urlRequest: URLRequest, data: Data?, response: URLResponse?) {
        print(#file, #function)
        let res: [String] = [
            "url: \(urlRequest.url?.absoluteString ?? "")",
            "status: \((response as? HTTPURLResponse)?.statusCode ?? 0)"
        ]
        let detail: [String] = [
            "response: \(response ?? URLResponse())",
            "data: \(String(describing: String(data: data ?? Data(), encoding: .utf8)))"
        ]
        print("レスポンス: {\(res.joined(separator: ", "))}")
        print("レスポンス詳細: {\(detail.joined(separator: ", "))}")
    }
}

public class URLRequestCreator {

    static func create(httpMethod: HttpMethod,
                              dto: RequestDto,
                              header: [String: String]?,
                              timeoutInterval: TimeInterval,
                              cachePolicy: URLRequest.CachePolicy) -> URLRequest {

        let urlRequest = NSMutableURLRequest()
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.cachePolicy = cachePolicy
        if let httpHeader = header {
            httpHeader.forEach {
                urlRequest.setValue($0.1, forHTTPHeaderField: $0.0)
            }
        }
        if httpMethod == .get {
            urlRequest.url = URL(string: appendGetParameter(url: dto.url, parameter: URLEncoder.encode(dto.params())))
        } else {
            urlRequest.url = URL(string: dto.url)
            urlRequest.httpBody = URLEncoder.encode(dto.params()).data(using: String.Encoding.utf8, allowLossyConversion: false)
        }
        #if DEBUG
        debugRequest(with: urlRequest as URLRequest)
        #endif
        return urlRequest as URLRequest
    }

    static func appendGetParameter(url: String, parameter: String) -> String {
        let separator: String
        if url.contains("?") {
            if ["?", "&"].contains(url.suffix(1)) {
                separator = ""
            } else {
                separator = "&"
            }
        } else {
            separator = "?"
        }
        return [url, parameter].joined(separator: separator)
    }

    static private func debugRequest(with urlRequest: URLRequest) {
        let details: [String] = [
            "timeoutInterval: \(urlRequest.timeoutInterval)",
            "method: \(urlRequest.httpMethod ?? "")",
            "cachePolicy: \(urlRequest.cachePolicy)",
            "allHTTPHeaderFields: \(urlRequest.allHTTPHeaderFields ?? [:])",
            "body: \(String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) ?? "")"
        ]
        let detail: String = details.joined(separator: ", ")
        print(#file, #function)
        print("リクエスト: {url: \(urlRequest.url?.absoluteString ?? "")}")
        print("リクエスト詳細: {\(detail)}")
    }
}

public class URLEncoder {
    public class func encode(_ parameters: [(key: String, value: String)]) -> String {
        let encodedString: String = parameters.compactMap {
            guard let value = $0.value.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else { return nil }
            return "\($0.key)=\(value)"
        }.joined(separator: "&")
        return encodedString
    }
}
