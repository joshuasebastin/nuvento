//
//  CoreDataModel.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import Foundation
import CoreData

@objc(DevicesInfo)
public class DevicesInfo: NSManagedObject {
}
extension DevicesInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DevicesInfo> {
        return NSFetchRequest<DevicesInfo>(entityName: "DevicesInfo")
    }

    @NSManaged public var deviceName: String?
    @NSManaged public var ipAddress: String?
    @NSManaged public var status: String?
}
