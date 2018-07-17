//
//  NetworkCommans.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

/// Common HTTP header fields.
///
/// - authorization: Authorization feild
/// - contentType: Content type `ContentType`.
/// - contentLength: Content length.
/// - acceptCharset: Accepted charset.
/// - acceptEncoding: Accept Encoding.
/// - date: date
/// - userAgent: userAgent
/// - contentDisposition: contentDisposition
/// - accept: accept
enum CommonHeaderFields: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
    case contentLength = "Content-Length"
    case acceptCharset = "Accept-Charset"
    case acceptEncoding = "Accept-Encoding"
    case date = "Date"
    case userAgent = "User-Agent"
    case contentDisposition = "Content-Disposition"
    case accept = "Accept"
}

/// Common content types.
///
/// - javascript: javascript
/// - json: json
/// - formUrlEncoded: formUrlEncoded
/// - xml: xml
/// - zip: zip
/// - pdf: pdf
/// - formData: formData
/// - css: css
/// - html: html
/// - plain: plain
/// - png: png
/// - jpeg: jpeg
/// - gif: gif
enum ContentType: String {

    case javascript = "application/javascript"
    case json = "application/json"
    case formUrlEncoded = "application/x-www-form-urlencoded"
    case xml = "application/xml"
    case zip = "application/zip"
    case pdf = "application/pdf"
    case formData = "multipart/form-data"
    case css = "text/css"
    case html = "text/html"
    case plain = "text/plain"
    case png = "image/png"
    case jpeg = "image/jpeg"
    case gif = "image/gif"
}

/// HTTP request methods.
enum HTTPMethod: String {

    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

/// Supported parameter encoding types.
enum ParameterEncoding {
    case json
}

/**
 This type wraps header key value pair and provides easy and typesafe interface to interact. 
*/
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
