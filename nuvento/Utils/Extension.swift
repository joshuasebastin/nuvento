//
//  Extension.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    // Function to set up the custom navigation bar
    func setupCustomNavigationBar(title: String, backButtonTitle: String = "Back", backAction: (() -> Void)? = nil) {
        
        // Create a container view for the custom navigation bar
        let navigationBarView = UIView()
        navigationBarView.backgroundColor = .systemBackground // You can customize this color
        
        // Add the title label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the back button
        let backButton = UIButton(type: .system)
        backButton.setTitle(backButtonTitle, for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal) // Customize the color if needed
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Add the views to the navigation bar
        navigationBarView.addSubview(titleLabel)
        navigationBarView.addSubview(backButton)
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the custom navigation bar to the view controller's view
        view.addSubview(navigationBarView)
        
        // Constraints for the custom navigation bar
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 44), // Customize the height if needed
            
            // Constraints for the title label
            titleLabel.centerXAnchor.constraint(equalTo: navigationBarView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor),
            
            // Constraints for the back button
            backButton.leadingAnchor.constraint(equalTo: navigationBarView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor)
        ])
        
    }
    
    // Back button action
    @objc private func backButtonTapped() {
            self.navigationController?.popViewController(animated: true)
    }
}
