//
//  Sourcery.swift
//  Automock
//
//  Created by Jeffery Trespalacios on 3/3/17.
//  Copyright © 2017 Jeffery Trespalacios. All rights reserved.
//

import Foundation

protocol AutoEquatable {}
protocol AutoMockable {}
protocol AutoHashable {}

extension DirectoryDelegate: AutoMockable {}
extension Contact: AutoEquatable, AutoHashable {}
