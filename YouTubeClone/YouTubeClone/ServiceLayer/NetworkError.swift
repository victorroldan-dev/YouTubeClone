//
//  NetworkError.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 27/02/22.
//

import Foundation
enum NetworkError: String, Error{
    case invalidURL
    case serializationFailed
    case generic
    case couldNotDecodeData
    case httpResponseError
    case statusCodeError
    case jsonDecoder
    case unauthorized
}

extension NetworkError : LocalizedError{
    public var errorDescription: String?{
        switch self{
        case .invalidURL:
            return NSLocalizedString("La URL es inválida", comment: "")
        case .serializationFailed:
            return NSLocalizedString("Falló ucando trató de serializar el body del request", comment: "")
        case .generic:
            return NSLocalizedString("La app falló por un error desconocido, validar API-Key", comment: "")
        case .couldNotDecodeData:
            return NSLocalizedString("No se pudo hacer el decode de la data", comment: "")
        case .httpResponseError:
            return NSLocalizedString("Imposible obtener el HTTPURLResponse", comment: "")
        case .statusCodeError:
            return NSLocalizedString("Es status code es diferente a 200", comment: "")
        case .jsonDecoder:
            return NSLocalizedString("Falló cuando leyó el JSON y no pudo decodificar.", comment: "")
        case .unauthorized:
            return NSLocalizedString("La sesión finalizó, vuelva a iniciarla.", comment: "")
        }
    }
}
