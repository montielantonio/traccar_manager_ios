//
// Copyright 2022 Anton Tananaev (anton@traccar.org)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import LocalAuthentication

class SecurityManager {
    
    private static let service = "traccar"
    private static let account = "traccar"
    
    static let shared = SecurityManager()
    
    private init() {}
    
    func saveToken(_ token: String) {
        let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .userPresence, nil)
        SecItemAdd([
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: SecurityManager.service,
            kSecAttrAccount: SecurityManager.account,
            kSecAttrAccessControl: access as Any,
            kSecValueData: Data(token.utf8),
        ] as CFDictionary, nil)
    }
    
    func readToken() -> String? {
        var result: AnyObject?
        SecItemCopyMatching([
            kSecAttrService: SecurityManager.service,
            kSecAttrAccount: SecurityManager.account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary, &result)
        if let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func deleteToken() {
        SecItemDelete([
            kSecAttrService: SecurityManager.service,
            kSecAttrAccount: SecurityManager.account,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary)
    }

}
