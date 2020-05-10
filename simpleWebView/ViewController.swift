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

    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        copyBundleToDocuments(fileExtension: "png")
        copyBundleToDocuments(fileExtension: "jpg")
        copyBundleToTemporary(fileExtension: "png")
        copyBundleToTemporary(fileExtension: "jpg")
        copyBundleToCache(fileExtension: "png")
        copyBundleToCache(fileExtension: "jpg")
        removeAtTemporaryFile(filename: "sige.jpg")
        removeAtCacheFile(filename: "sige.jpg")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webView.uiDelegate = self
        let myURL = Bundle.main.url(forResource: "index", withExtension: "html")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    
    @IBAction func touchUpButton(_ sender: Any) {
        webView.evaluateJavaScript("updateHTML()", completionHandler: nil)
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

