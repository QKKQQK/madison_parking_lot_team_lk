//
//  Utilities.swift
//  mapApp
//
//  Created by Lijie Zhao on 8/29/17.
//  Copyright © 2017 team_lk. All rights reserved.
//

import Foundation

public enum HTTPStatusCode: Int {
    case `continue`                   = 100
    case switchingProtocols           = 101
    case ok                           = 200
    case created                      = 201
    case accepted                     = 202
    case nonAuthoritativeInformation  = 203
    case noContent                    = 204
    case resetContent                 = 205
    case partialContent               = 206
    case multipleChoices              = 300
    case movedPermanently             = 301
    case found                        = 302
    case seeOther                     = 303
    case notModified                  = 304
    case useProxy                     = 305
    case temporaryRedirect            = 307
    case badRequest                   = 400
    case unauthorized                 = 401
    case paymentRequired              = 402
    case forbidden                    = 403
    case notFound                     = 404
    case methodNotAllowed             = 405
    case notAcceptable                = 406
    case proxyAuthenticationRequired  = 407
    case requestTimeOut               = 408
    case conflict                     = 409
    case gone                         = 410
    case lengthRequired               = 411
    case preconditionFailed           = 412
    case requestEntityTooLarge        = 413
    case requestURITooLarge           = 414
    case unsupportedMediaType         = 415
    case requestedRangeNotSatisfiable = 416
    case expectationFailed            = 417
    case internalServerError          = 500
    case notImplemented               = 501
    case badGateway                   = 502
    case serviceUnavailable           = 503
    case gatewayTimeOut               = 504
    case httpVersionNotSupported      = 505
}
