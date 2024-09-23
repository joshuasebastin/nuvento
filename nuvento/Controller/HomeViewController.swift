//
//  HomeViewController.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var deviceListTableView: UITableView!
    
    let coredataViewModel:CoreDataManager =  CoreDataManager()
    var services = [NetService]()
    var netServiceBrowser: NetServiceBrowser = NetServiceBrowser()
    var deviceDetails:[DevicesInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        netServiceBrowser.delegate = self
        startDiscovery()
        setupCustomNavigationBar(title: "Home")
        deviceListTableView.register(UINib(nibName: "DevicesListTableViewCell", bundle: nil), forCellReuseIdentifier: "DeviceListCell")
        getDeviceDetails()
        setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    func setUpUI(){
        deviceListTableView.delegate = self
        deviceListTableView.dataSource = self
    }
    func getDeviceDetails(){
        deviceDetails = coredataViewModel.fetchDevices()
        deviceListTableView.reloadData()
    }
    func navigationToHomeScreen(){
        if let detailScreen = self.storyboard?.instantiateViewController(withIdentifier: "DetailsScreenViewControllerID") as? DetailsScreenViewController {
            self.navigationController?.pushViewController(detailScreen, animated: false)
        }
    }
    
}
// MARK: - Tablview delegate
extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceListCell", for: indexPath) as? DevicesListTableViewCell {
            cell.DeviceNameLabel.text = deviceDetails?[indexPath.row].deviceName ?? ""
            cell.ipAddressLabel.text = "\(deviceDetails?[indexPath.row].ipAddress ?? "")"
            cell.StatusLabel.text = deviceDetails?[indexPath.row].status ?? ""
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationToHomeScreen()
    }
}
// MARK: - Network services
extension HomeViewController:  NetServiceBrowserDelegate, NetServiceDelegate{
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
        if deviceDetails?.isEmpty ?? false {
            if ipAddress != ""{
                coredataViewModel.createDevice(deviceName: "Device name: \(deviceName)", ipAddress: "iP Address : \(ipAddress ?? "")", status: "Rechable")
                coredataViewModel.saveContext()
            }
            self.getDeviceDetails()
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
                self.getDeviceDetails()
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

