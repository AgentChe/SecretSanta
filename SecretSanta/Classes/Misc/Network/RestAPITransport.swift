//
//  RestAPITransport.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 12.12.2025.
//

import RxSwift
import Alamofire

final class RestAPITransport {
    private let session: Session

    init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 60
        self.session = Session(configuration: configuration)
    }

    func share(data: ShareDataRequest) -> Single<Any> {
        Single.create { [session] single in
            let encodedUrl = data.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? data.url

            let pairs: [(email: String, pdfUrl: URL)] = data.body
                .map { (email: $0.key, pdfUrl: $0.value) }
                .sorted { $0.email.localizedCaseInsensitiveCompare($1.email) == .orderedAscending }

            let request = session.upload(
                multipartFormData: { multipart in
                    for (idx, pair) in pairs.enumerated() {
                        if let emailData = pair.email.data(using: .utf8) {
                            multipart.append(emailData, withName: "email[\(idx)]")
                        }
                        multipart.append(
                            pair.pdfUrl,
                            withName: "data[\(idx)]",
                            fileName: "secret_santa_\(idx).pdf",
                            mimeType: "application/pdf"
                        )
                    }
                },
                to: encodedUrl,
                method: .post,
                headers: ["Access-Token": GlobalDefinitions.apiKey]
            )
            .validate(statusCode: [200, 201])
            .response { response in
                if let error = response.error {
                    single(.failure(NetworkError(.serverNotAvailable, underlyingError: error)))
                } else if let responseData = response.data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                        single(.success(json))
                    } catch {
                        single(.failure(NetworkError(.serverNotAvailable, underlyingError: error)))
                    }
                } else {
                    single(.failure(NetworkError(.serverNotAvailable)))
                }
            }

            return Disposables.create { request.cancel() }
        }
    }
}
