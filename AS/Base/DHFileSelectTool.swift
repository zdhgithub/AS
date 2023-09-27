//
//  DHFileSelectTool.swift
//  AS
//
//  Created by dh on 2023/9/27.
//

import UIKit
import UniformTypeIdentifiers

class DHFileSelectTool: NSObject {
    
    static let sharedInstance = DHFileSelectTool()

    private override init() {}
    
    var callback:((URL?)->())!
    
    func openDocument(export: @escaping (URL?)->()) {
        let type = UTType(filenameExtension: "p8")!
        let dpcv = UIDocumentPickerViewController(forOpeningContentTypes: [type])
        dpcv.allowsMultipleSelection = false
        dpcv.delegate = self;
        dpcv.modalPresentationStyle = .fullScreen;
        UIViewController.mo_current().present(dpcv, animated: true)
        
        callback = export
    }
    
}


extension DHFileSelectTool:UIDocumentPickerDelegate{
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
       callback(nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        /// 设置回UIScrollViewContentInsetAdjustmentNever
//            if (@available(iOS 11, *)) {
//                UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            }
        let url = urls.first!
        let fileUrlAuthozied = url.startAccessingSecurityScopedResource()
        if fileUrlAuthozied {
            let fileCoordinator = NSFileCoordinator()
            var err:NSError?
            fileCoordinator.coordinate(readingItemAt: url, error: &err) { newURL in
                debugPrint("选择的文件地址===" + newURL.absoluteString)
                callback(newURL)
            }
            url.stopAccessingSecurityScopedResource()
        }else{
            ZWTProgressHUD.zwt_showMessage("此文件不可用")
            callback(nil)
        }
           
    }
}

extension DHFileSelectTool:UIDocumentInteractionControllerDelegate{
    
}

