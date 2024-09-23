//
//  DetailsScreenViewController.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import UIKit

class DetailsScreenViewController: UIViewController {
    private var addWeatherVM = AddWeatherViewModel()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var ipAddressLabel: UILabel!
    @IBOutlet weak var postalLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoaderManager.shared.showLoader(in: self.view)
        self.navigationController?.isNavigationBarHidden = true
        setupCustomNavigationBar(title: "Ip Details")
        getAPIS()
    }
    func getAPIS() {
        LoaderManager.shared.showLoader(in: self.view)

        addWeatherVM.loadWeatherData(for: .ipAddress, modelType: ipAddressModel.self) { [weak self] model in
            guard let self = self else { return }
            if let model = model {
                self.addWeatherVM.loadWeatherData(for: .ipAddressInfo(model.ip), modelType: IPAddressInfoModel.self) { [weak self] information in
                    guard let self = self else { return }
                    if let info = information {
                        DispatchQueue.main.async {
                            self.setDetails(details: info)
                        }
                    } else {
                        DispatchQueue.main.async {
                            LoaderManager.shared.hideLoader()
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    LoaderManager.shared.hideLoader()
                }
            }
        }
    }

    func setDetails(details: IPAddressInfoModel) {
        self.cityLabel.text = details.city
        self.companyLabel.text = details.org
        self.ipAddressLabel.text = details.ip
        self.postalLabel.text = details.postal
        self.regionLabel.text = details.region
        LoaderManager.shared.hideLoader()
    }

}
