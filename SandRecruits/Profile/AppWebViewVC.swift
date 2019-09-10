//
//  AppWebViewVC.swift
//  SandRecruits
//
//  Created by Keyur on 09/05/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit
import WebKit

class AppWebViewVC: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var appWebView: WKWebView!
    
    var strUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appWebView.uiDelegate = self
        appWebView.navigationDelegate = self
        
        appWebView.load(URLRequest.init(url: URL(string: strUrl)!))
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("***** START ******")
        showLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("***** END ******")
        removeLoader()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("***** FAILED ******")
        removeLoader()
        print(error.localizedDescription)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
