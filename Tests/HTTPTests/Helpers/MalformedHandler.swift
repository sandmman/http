// This source file is part of the Swift.org Server APIs open source project
//
// Copyright (c) 2017 Swift Server API project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
//

import Foundation
import HTTP

/// Simple `HTTPRequestHandler` that returns 200: OK without a body
class MalformedHandler: HTTPRequestHandling {
    var status: HTTPResponseStatus = .noContent

    func handle(request: HTTPRequest, response: HTTPResponseWriter ) -> HTTPBodyProcessing {
        response.writeHeader(status: status, headers: [.transferEncoding: "test", .contentLength: "5"])
        return .discardBody
    }
}
