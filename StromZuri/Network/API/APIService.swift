//
//  APIService.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 26/01/24.
//


protocol APIServiceProtocol {
    func performRequest<T: Decodable>(
        endpoint: Endpoint,
        config: RequestConfig, completion: @escaping (Result<T, Error>) -> Void
    )
}

final class APIService: APIServiceProtocol {
    private var baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func performRequest<T: Decodable>(
        endpoint: Endpoint,
        config: RequestConfig,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = buildURL(for: endpoint, queryParameters: config.queryParameters) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = config.method.rawValue
        request.allHTTPHeaderFields = config.headers
        request.httpBody = config.requestData
        request.timeoutInterval = 60
        
        debugPrint("URLRequest: \n" + request.debugDescription)
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let data = data, let response = response {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    debugPrint("\nURLResponse: \n" + response.debugDescription)
                    let decodedResponse = try decoder.decode(T.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(decodedResponse))
                    }
                } catch {
                    DispatchQueue.main.async {
                        debugPrint(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
    private func buildURL(for endpoint: Endpoint, queryParameters: [String: String]?) -> URL? {
        guard let baseURL = URL(string: baseURL) else {
            return nil
        }
        
        let endpointPath: String = endpoint.path

        var components = URLComponents(
            url: baseURL.appendingPathComponent(endpointPath), 
            resolvingAgainstBaseURL: true
        )
        components?.queryItems = queryParameters?.compactMap { URLQueryItem(name: $0, value: $1) }

        return components?.url
    }
}
