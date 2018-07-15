//
//  NetworkCommans.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

enum CommonHeaderFields: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
    case contentLength = "Content-Length"
    case contentMD5 = "Content-MD5"
    case acceptCharset = "Accept-Charset"
    case acceptEncoding = "Accept-Encoding"
    case date = "Date"
    case userAgent = "User-Agent"
    case contentDisposition = "Content-Disposition"
    case accept = "Accept"
    case xAuthToken = "X-Auth-Token"
}

enum ContentType: String {

    case javascript = "application/javascript"
    case json = "application/json"
    case formUrlEncoded = "application/x-www-form-urlencoded"
    case xml = "application/xml"
    case zip = "application/zip"
    case pdf = "application/pdf"
    case mpeg = "audio/mpeg"
    case vorbis = "audio/vorbis"
    case formData = "multipart/form-data"
    case css = "text/css"
    case html = "text/html"
    case plain = "text/plain"
    case png = "image/png"
    case jpeg = "image/jpeg"
    case gif = "image/gif"

}

enum HTTPMethod: String {

    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum ParameterEncoding {
    case url
    case json
}

enum HTTPHeader {

    case contentDisposition(String)
    case accept([ContentType])
    case contentType(ContentType)
    case authorization(String)
    case custom(String, String)

    var field: String {
        switch self {
        case .contentDisposition:
            return CommonHeaderFields.contentDisposition.rawValue
        case .accept:
            return CommonHeaderFields.accept.rawValue
        case .contentType:
            return CommonHeaderFields.contentType.rawValue
        case .authorization:
            return CommonHeaderFields.authorization.rawValue
        case .custom(let key, _):
            return key
        }
    }

    var value: String {
        switch self {
        case .contentDisposition(let disposition):
            return disposition
        case .accept(let types):
            return types.map { $0.rawValue }.joined(separator: ", ")
        case .contentType(let type):
            return type.rawValue
        case .authorization(let token):
            return token
        case .custom(_, let value):
            return value
        }
    }

}

enum NotesAPIError: Error {
    case invalidURL
    case invalidResponse
    case noData
}
