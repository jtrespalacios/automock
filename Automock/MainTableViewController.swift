//
//  MainTableViewController.swift
//  Automock
//
//  Created by Jeffery Trespalacios on 3/2/17.
//  Copyright © 2017 Jeffery Trespalacios. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    let directory = Directory()
    let creationContext = ContactCreationContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Directory"
        self.tableView.dataSource = self.directory
    }

    @IBAction func showCreateAccountAlert() {
        let alert = UIAlertController(title: "Create Contact", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Name" }
        alert.addTextField { $0.placeholder = "Number" }
        alert.addTextField { $0.placeholder = "Address" }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let fields = alert.textFields, fields.count == 3 else { return }
            guard let name = fields[0].text, let phone = fields[1].text, let address = fields[2].text else { return }
            guard let contact = self.creationContext.createContact(named: name, phoneNumber: phone, address: address) else {
                self.showFailedToCreateAlert()
                return
            }
            self.directory.insert(contact: contact)

        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showFailedToCreateAlert() {
        let alert = UIAlertController(title: "Error", message: "Failed to create contact", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainTableViewController: ContactFormControllerDelegate {
    func contactForm(controller: ContactFormController, createdContact contact: Contact) {
        self.directory.insert(contact: contact)
        self.dismiss(animated: true, completion: nil)
    }
}

protocol ContactFormControllerDelegate: class {
    func contactForm(controller: ContactFormController, createdContact contact: Contact)
}

class ContactFormController: UIViewController {
    var contactCreationContext: ContactCreationContext!
    weak var delegate: ContactFormControllerDelegate?
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var addressField: UITextField!

    @IBAction func didTapAddButton() {
        guard let name = nameField.text, let number = numberField.text, let address = addressField.text else {
            return
        }

        if let contact = self.contactCreationContext.createContact(named: name, phoneNumber: number, address: address) {
            self.delegate?.contactForm(controller: self, createdContact: contact)
        }
    }
}

struct Contact {
    let name: String
    let phoneNumber: String
    let address: String
}

extension Contact: Equatable {}
func ==(lhs: Contact, rhs: Contact) -> Bool {
    return lhs.name == rhs.name && lhs.phoneNumber == rhs.phoneNumber && lhs.address == rhs.address
}

protocol DirectoryDelegate: class {
    func added(contact: Contact, fromDirectory directory: Directory)
    func removed(contact: Contact, fromDirectory directory: Directory)
}

class Directory: NSObject {
    var contacts = [Contact]()
    weak var delegate: DirectoryDelegate?

    func insert(contact: Contact) {
        self.contacts.append(contact)
        self.delegate?.added(contact: contact, fromDirectory: self)
    }

    func delete(contact: Contact) {
        if let index = self.contacts.index(of: contact) {
            self.delegate?.removed(contact: contact, fromDirectory: self)
            self.contacts.remove(at: index)
        }
    }
}

extension Directory: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier) as! CustomCell
        let contact = self.contacts[indexPath.row]
        cell.name = contact.name
        cell.phoneNumber = contact.phoneNumber
        cell.address = contact.address
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
}

class CustomCell: UITableViewCell {
    static let identifier = "Custom"
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!

    public var name: String? {
        get { return nameLabel.text }
        set { nameLabel.text = newValue }
    }

    public var phoneNumber: String? {
        get { return phoneNumberLabel.text }
        set { phoneNumberLabel.text = newValue }
    }

    public var address: String? {
        get { return addressLabel.text }
        set { addressLabel.text = newValue }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.name = nil
        self.phoneNumber = nil
        self.address = nil
    }
}

class ContactCreationContext {
    func createContact(named: String, phoneNumber: String, address: String) -> Contact? {
        guard named.characters.count > 1 && phoneNumber.characters.count == 10 && address.characters.count > 1 else {
            return nil
        }

        return Contact(name: named, phoneNumber: phoneNumber, address: address)
    }
}
