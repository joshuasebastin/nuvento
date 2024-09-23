//
//  LoaderManager.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import UIKit

class LoaderManager {
    
    static let shared = LoaderManager()
    private var loaderView: LoaderView?
    
    private init() {}  // Singleton pattern
    
    func showLoader(in view: UIView) {
        guard loaderView == nil else { return }  // Don't add if loader is already visible

        // Create the loader view
        let loaderSize: CGFloat = 50
        let loaderView = LoaderView(frame: CGRect(x: 0, y: 0, width: loaderSize, height: loaderSize))
        loaderView.center = view.center
        loaderView.alpha = 0  // Start transparent
        
        // Add loader view to the provided view
        view.addSubview(loaderView)
        self.loaderView = loaderView
        
        // Fade in animation
        UIView.animate(withDuration: 0.3) {
            loaderView.alpha = 1
        }
    }
    
    func hideLoader() {
        guard let loaderView = loaderView else { return }

        // Fade out animation
        UIView.animate(withDuration: 0.3, animations: {
            loaderView.alpha = 0
        }) { _ in
            loaderView.removeFromSuperview()  // Remove loader view after fade-out
            self.loaderView = nil
        }
    }
}

