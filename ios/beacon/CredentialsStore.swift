import Foundation
import Security

enum CredentialsStore {
    private static let service = Bundle.main.bundleIdentifier ?? "link.whitekiwi.beacon"
    private static let account = "apiSecret"

    static var apiSecret: String {
        get {
            if let value = read() {
                return value
            }

            let defaults = UserDefaults.standard
            guard let legacyValue = defaults.string(forKey: account), !legacyValue.isEmpty else {
                return ""
            }
            save(legacyValue)
            defaults.removeObject(forKey: account)
            return legacyValue
        }
        set {
            if newValue.isEmpty {
                delete()
            } else {
                save(newValue)
            }
        }
    }

    private static func read() -> String? {
        var query = baseQuery
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data
        else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private static func save(_ value: String) {
        let data = Data(value.utf8)
        let status = SecItemUpdate(
            baseQuery as CFDictionary,
            [kSecValueData as String: data] as CFDictionary
        )
        if status == errSecItemNotFound {
            var query = baseQuery
            query[kSecValueData as String] = data
            query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            SecItemAdd(query as CFDictionary, nil)
        }
    }

    private static func delete() {
        SecItemDelete(baseQuery as CFDictionary)
    }

    private static var baseQuery: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
    }
}
