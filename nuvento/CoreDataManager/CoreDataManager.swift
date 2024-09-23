//
//  CoreDataManager.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    @discardableResult
    func createDevice(deviceName: String, ipAddress: String, status: String) -> DevicesInfo? {
        let newDevice = DevicesInfo(context: context)
        newDevice.deviceName = deviceName
        newDevice.ipAddress = ipAddress
        newDevice.status = status
        saveContext()
        return newDevice
    }
    
    func fetchDevices() -> [DevicesInfo]? {
        let fetchRequest: NSFetchRequest<DevicesInfo> = DevicesInfo.fetchRequest()
        
        do {
            let devices = try context.fetch(fetchRequest)
            return devices
        } catch {
            print("Failed to fetch devices: \(error)")
            return nil
        }
    }
    func clearCoreData() {
        let context = self.context
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DevicesInfo")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            print("Could not clear Core Data. \(error), \(error.userInfo)")
        }
    }

}
