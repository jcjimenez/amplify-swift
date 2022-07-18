//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import Amplify

public class AWSAuthWebUISignInOperation: AmplifyOperation<
    AuthWebUISignInRequest,
    AuthSignInResult,
    AuthError
>, AuthWebUISignInOperation {

    let helper: HostedUISignInHelper

    init(_ request: AuthWebUISignInRequest,
         authConfiguration: AuthConfiguration,
         authStateMachine: AuthStateMachine,
         resultListener: ResultListener?) {

        self.helper = HostedUISignInHelper(request: request,
                                           authstateMachine: authStateMachine,
                                           configuration: authConfiguration)
        super.init(categoryType: .auth,
                   eventName: HubPayload.EventName.Auth.webUISignInAPI,
                   request: request,
                   resultListener: resultListener)
    }

    override public func main() {
        if isCancelled {
            finish()
            return
        }

        helper.initiateSignIn { result in
            self.dispatch(result: result)
            self.finish()
        }

    }
}
