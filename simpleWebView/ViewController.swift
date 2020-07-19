//
//  ViewController.swift
//  simpleWebView
//
//  Created by Masahiro Tamamura on 2020/05/10.
//  Copyright © 2020 Masahiro Tamamura. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var result1Label: UILabel!
    @IBOutlet weak var result2Label: UILabel!
    @IBOutlet weak var result3Label: UILabel!

    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coptyFile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let webConfig = WKWebViewConfiguration()
        let myURL = Bundle.main.url(forResource: "index", withExtension: "html")
        let myRequest = URLRequest(url: myURL!)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.load(myRequest)
    }

    func toJavaScript() {

    }
    
    @IBAction func touchUpButton(_ sender: Any) {
//        webView.evaluateJavaScript("updateHTML()", completionHandler: nil)
        webView.evaluateJavaScript("updateHTML1()") { (result, error) in
            if error == nil {
                print(result.debugDescription)
                let str = result as! String
                self.result1Label.text = str
            } else {
                print("Error! \(error.debugDescription)")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.webView.evaluateJavaScript("updateHTML2()") { (result, error) in
                if error == nil {
                    if result != nil {
                        print(result.debugDescription)
                        do {
                            let str = result as! String
                            try self.result2Label.text = str
                        } catch {
                            self.result2Label.text = "error"
                        }
                    } else {
                        self.result2Label.text = "error"
                    }
                }else{
                    print("Error! \(error.debugDescription)")
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.webView.evaluateJavaScript("updateHTML3()") { (result, error) in
                if error == nil {
                    print(result.debugDescription)
                    let str = result as! String
                    self.result3Label.text = str
                } else {
                    print("Error! \(error.debugDescription)")
                }
            }
        }
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
                let url = navigationAction.request.url
        print("decidePolicyFor: \(url)")
        decisionHandler(.allow)
    }

//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        let url = navigationAction.request.url
//        print("didFinish: \(url)")
//        decisionHandler(.allow)
//    }
}


extension ViewController : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        let dict = message.body as? Dictionary<String, String>
        print(dict?.description)
    }
}

extension ViewController {
    func coptyFile(){
        copyBundleToDocuments(fileExtension: "png")
        copyBundleToDocuments(fileExtension: "jpg")
        copyBundleToTemporary(fileExtension: "png")
        copyBundleToTemporary(fileExtension: "jpg")
        copyBundleToCache(fileExtension: "png")
        copyBundleToCache(fileExtension: "jpg")
        removeAtTemporaryFile(filename: "sige.jpg")
        removeAtCacheFile(filename: "sige.jpg")
    }
    
    func copyBundleToDocuments(fileExtension: String) {
        if let resPath = Bundle.main.resourcePath {
            do {
                let dirContents = try FileManager.default.contentsOfDirectory(atPath: resPath)
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let filteredFiles = dirContents.filter{ $0.contains(fileExtension)}
                for fileName in filteredFiles {
                    if let documentsURL = documentsURL {
                        let sourceURL = Bundle.main.bundleURL.appendingPathComponent(fileName)
                        let destURL = documentsURL.appendingPathComponent(fileName)
                        print(destURL)
                        do { try FileManager.default.copyItem(at: sourceURL, to: destURL) } catch { }
                    }else{
                        print("throuth")
                    }
                }
            } catch {
                print("error")
                return
            }
        }
    }
    
    func copyBundleToTemporary(fileExtension: String) {
        if let resPath = Bundle.main.resourcePath {
            do {
                let dirContents = try FileManager.default.contentsOfDirectory(atPath: resPath)
                let path = NSTemporaryDirectory() as String
                let documentsURL = URL(fileURLWithPath: path)
                let filteredFiles = dirContents.filter{ $0.contains(fileExtension)}
                for fileName in filteredFiles {
                    //                    if let documentsURL = documentsURL {
                    let sourceURL = Bundle.main.bundleURL.appendingPathComponent(fileName)
                    let destURL = documentsURL.appendingPathComponent(fileName)
                    print(destURL)
                    do { try FileManager.default.copyItem(at: sourceURL, to: destURL) } catch { }
                    //                    }
                }
            } catch {
                print("error")
                return
            }
        }
    }
    
    func copyBundleToCache(fileExtension: String) {
        if let resPath = Bundle.main.resourcePath {
            do {
                let dirContents = try FileManager.default.contentsOfDirectory(atPath: resPath)
                let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
                let filteredFiles = dirContents.filter{ $0.contains(fileExtension)}
                for fileName in filteredFiles {
                    if let documentsURL = documentsURL {
                        let sourceURL = Bundle.main.bundleURL.appendingPathComponent(fileName)
                        let destURL = documentsURL.appendingPathComponent(fileName)
                        print(destURL)
                        do { try FileManager.default.copyItem(at: sourceURL, to: destURL) } catch { }
                    }else{
                        print("throuth:")
                    }
                }
            } catch {
                print("error")
                return
            }
        }
    }
    
    func removeAtCacheFile(filename: String) {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        let documentsURL = url.appendingPathComponent(filename, isDirectory: false)
        do {
            try FileManager.default.removeItem(at: documentsURL)
        }catch{
            print("remove error")
        }
    }
    
    func removeAtTemporaryFile(filename: String) {
        
        let path = NSTemporaryDirectory() as String
        let documentsURL = URL(fileURLWithPath: path + filename)
        do {
            try FileManager.default.removeItem(at: documentsURL)
        }catch{
            print("remove error")
        }
    }
}
