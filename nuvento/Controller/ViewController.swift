//
//  ViewController.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let coredataViewModel:CoreDataManager =  CoreDataManager()
    var services = [NetService]()
    var netServiceBrowser: NetServiceBrowser = NetServiceBrowser()
    private var addWeatherVM = AddWeatherViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        netServiceBrowser.delegate = self
        coredataViewModel.clearCoreData()
        addWeatherVM.loadWeatherData(for: .ipAddress, modelType: ipAddressModel.self) { model in
            if let modelss = model {
                print(modelss.ip,"IDns,ndalksndlkasndlnasd")
            }
        }
        // Fetching devices
        if let devices = coredataViewModel.fetchDevices() {
            for device in devices {
                print("Device Name: \(device.deviceName), IP Address: \(device.ipAddress), Status: \(device.status)")
            }
        }
        startDiscovery()
    }
   

}

extension ViewController:  NetServiceBrowserDelegate, NetServiceDelegate{
    func startDiscovery() {
        netServiceBrowser.delegate = self
        netServiceBrowser.searchForServices(ofType: "_airplay._tcp.", inDomain: "")
    }
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("Service found: \(service)")
        services.append(service)
        service.delegate = self
        service.resolve(withTimeout: 10.0)
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        let ipAddress = getIpAddress(sender)
        let deviceName = sender.name
        print("Device name: \(deviceName)")
        print("iP Address : \(ipAddress ?? "")")
        if ipAddress != ""{
            coredataViewModel.createDevice(deviceName: "Device name: \(deviceName)", ipAddress: "iP Address : \(ipAddress ?? "")", status: "Rechable")
            coredataViewModel.saveContext()
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        let fetchRequest: NSFetchRequest<DevicesInfo> = DevicesInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "deviceName == %@", service.name)
        
        do {
            let fetchedDevices = try CoreDataManager().context.fetch(fetchRequest)
            if let device = fetchedDevices.first {
                device.status = "UnRechable"
                CoreDataManager().saveContext()
            }
        } catch {
            print("Failed to save device: \(error)")
        }
    }
    
    
    func getIpAddress(_ service: NetService) -> String?{
        if let addresses = service.addresses, !addresses.isEmpty {
            let data = addresses[0]
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            data.withUnsafeBytes { ptr in
                guard let addr = ptr.baseAddress?.assumingMemoryBound(to: sockaddr.self) else { return }
                getnameinfo(addr, socklen_t(data.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST)
            }
            let ipAddress = String(cString: hostname)
            return ipAddress
        }
        
        return ""
    }
}
