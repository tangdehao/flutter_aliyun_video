//
//  OpenViewController.swift
//  aliyun_video
//
//  Created by 李鹏达 on 2020/1/18.
//

import Foundation
typealias DictClosure = (_ dict: [String: Any]) -> Void

class OpenViewController: UIViewController {
    
    private var retryClosure: DictClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        button.backgroundColor = UIColor.blue
        view.addSubview(button)
        button.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
    }
    
    @objc private func retryAction() {
        if retryClosure != nil {
            retryClosure!(["fileType": "0", "filePath": "http://foo"])
        }
        self.dismiss(animated: true) {
            
        }
    }
    
    public func retry(_ closure: @escaping DictClosure) {
        retryClosure = closure
    }
}

