//
//  ContactsManager.swift
//  TodoList
//
//  Created by Usama Jamil on 26/03/2020.
//  Copyright © 2020 Usama Jamil. All rights reserved.
//

import Foundation
import ContactsUI


enum ContactsFilter {
    case none
    case mail
    case message
}

struct PhoneContact {
    var givenName: String
    var middleName: String
    var familyName: String
    var number: String
    var numberLabel: String
    var emailAddress: String
    
    var fullName: String {
        return "\(givenName)\(middleName.isEmpty ? "" : " \(middleName)")\(familyName.isEmpty ? "" : " \(familyName)")"
    }
    
//    var numberFormatted: String {
//        do {
//            return try PhoneNumberManager.validate(number, with: .e164)
//        } catch {
//            return ""
//        }
//    }
//
//    var json: [String: String] {
//        return ["mobileNumber": numberFormatted, "contactName": fullName]
//    }
}

class ContactsManager {
    
    //MARK: - Properties
    
    static let manager = ContactsManager()
    
    //MARK: - Helpers
    
    private func getContacts(from contactStore: CNContactStore, filter: ContactsFilter = .none) -> [CNContact] {
        
        var results: [CNContact] = []
        
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey, CNContactEmailAddressesKey] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            return results
        }
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                return results
            }
        }
        
        return results
    }
    
    
    private func contactsAuthorization(for store: CNContactStore, completionHandler: @escaping ((_ isAuthorized: Bool) -> Void)) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
        case .notDetermined:
            store.requestAccess(for: CNEntityType.contacts, completionHandler: { (isAuthorized: Bool, error: Error?) in
                completionHandler(isAuthorized)
            })
        case .denied:
            completionHandler(false)
        case .restricted:
            completionHandler(false)
        @unknown default:
            completionHandler(false)
        }
    }
    
    private func parse(_ contact: CNContact) -> PhoneContact? {
        
        for phoneNumber in contact.phoneNumbers {
            if let label = phoneNumber.label {
                let number = phoneNumber.value
                let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                let emails = contact.emailAddresses
                var emailString = ""
                if emails.count > 0 {
                    emailString = emails[0].value as String
                }
                
                return PhoneContact(givenName: contact.givenName, middleName: contact.middleName, familyName: contact.familyName, number: number.stringValue, numberLabel: localizedLabel, emailAddress: emailString)
            }
            
        }
        
        return nil
    }
    
    //MARK: - Actions
    
    func fetchAllContacts(completionHandler: @escaping (([PhoneContact], Error?) -> Void)) {
        
        var phoneContacts = [PhoneContact]()
        
        let contactStore = CNContactStore()
        
        contactsAuthorization(for: contactStore) { isAuthorized in
            if isAuthorized {
                let contacts = self.getContacts(from: contactStore)
                for contact in contacts {
                    if let phoneContact = self.parse(contact) {
                        //if phoneContact.givenName != "SPAM" && phoneContact.numberFormatted != "" {
                        if !(phoneContact.emailAddress.isEmpty) {
                            phoneContacts.append(phoneContact)
                        }
                        //}
                    } else {
                        continue
                    }
                }
                completionHandler(phoneContacts, nil)
            } else {
                completionHandler(phoneContacts, NSError.init(errorMessage: ""))
            }
        }
    }
}
