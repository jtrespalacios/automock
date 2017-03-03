// Generated using Sourcery 0.5.8 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


class DirectoryDelegateMock: DirectoryDelegate {


//MARK: - added

var addedCalled = false
var addedReceivedArguments: (contact: Contact, directory: Directory)?

func added(contact: Contact, fromDirectory directory: Directory) {

addedCalled = true
addedReceivedArguments = (contact: contact, directory: directory)
}

//MARK: - removed

var removedCalled = false
var removedReceivedArguments: (contact: Contact, directory: Directory)?

func removed(contact: Contact, fromDirectory directory: Directory) {

removedCalled = true
removedReceivedArguments = (contact: contact, directory: directory)
}

}
