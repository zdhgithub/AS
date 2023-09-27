//
//  DHBundleIDModel.swift
//  AS
//
//  Created by dh on 2023/9/19.
//

import UIKit
import HandyJSON

class DHAccountModel : HandyBaseModel {
    var issuserId:String = ""
    var p8keyId:String = ""
    var p8keyContent:String = ""
    var name:String = ""
    //是否选中
    var sel:Int=0
}

// MARK: - errors
class DHErrorsModel:HandyBaseModel{
    var id:String = ""
    var status:String = ""
    var code:String = ""
    var title:String = ""
    var detail:String = ""
    var pointer:String = ""
    
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            pointer <-- "source.pointer"
    }
}

// MARK: - Bundle
class DHBundleIDModel: DHBaseModel {
    var attributes:DHAttributesBID!
    var relationships:DHRelationshipsBID!
}

class DHAttributesBID:HandyBaseModel{
    var name:String = ""
    var identifier:String = ""
    var platform:String = ""
    var seedId:String = ""
}

class DHRelationshipsBID:HandyBaseModel{
    var bundleIdCapabilities:DHLinks!
    var profiles:DHLinks!
}

// MARK: - Profils

class DHProfileModel: DHBaseModel {
    var attributes:DHAttributesProfile!
    var relationships:DHRelationshipsProfile!
}

class DHAttributesProfile:HandyBaseModel{
    var profileState:String = ""
    var createdDate:String = ""
    var profileType:String = ""
    var name:String = ""
    var profileContent:String = ""
    var uuid:String = ""
    var platform:String = ""
    var expirationDate:String = ""
}

class DHRelationshipsProfile:HandyBaseModel{
    var bundleId:DHLinks!
    var certificates:DHLinks!
    var devices:DHLinks!
}
// MARK: - Capabilities

class DHCapabilitiesModel: DHBaseModel {
    var attributes:DHAttributesCapabilities!
    var relationships:DHRelationshipsCapabilities!
}

class DHAttributesCapabilities:HandyBaseModel{
    var settings:String = ""
    var capabilityType:String = ""
}

class DHRelationshipsCapabilities:HandyBaseModel{
    var bundleId:DHLinks!
}

// MARK: - Certificates

class DHCertificateModel: DHBaseModel {
    var attributes:DHAttributesCertificate!
    var relationships:DHRelationshipsCertificate!
}

class DHAttributesCertificate:HandyBaseModel{
    var serialNumber:String = ""
    var certificateContent:String = ""
    var displayName:String = ""
    var name:String = ""
    var csrContent:String = ""
    var platform:String = ""
    var expirationDate:String = ""
    var certificateType:String = ""
}

class DHRelationshipsCertificate:HandyBaseModel{
    var passTypeId:DHLinks!
}

// MARK: - Decives

class DHDecivesModel: DHBaseModel {
    var attributes:DHAttributesDecives!
}

class DHAttributesDecives:HandyBaseModel{
    var addedDate:String = ""
    var deviceClass:String = ""
    var model:String = ""
    var name:String = ""
    var platform:String = ""
    var status:String = ""
    var udid:String = ""
}

// MARK: - Users

class DHUserModel: DHBaseModel {
    var attributes:DHAttributesUser!
    var relationships:DHRelationshipsUser!
}

class DHAttributesUser:HandyBaseModel{
    var username:String = ""
    var firstName:String = ""
    var lastName:String = ""
    var allAppsVisible:Bool = false
    var provisioningAllowed:Bool = false
    var roles:[String] = [String]()
}

class DHRelationshipsUser:HandyBaseModel{
    var visibleApps:DHLinks!
}
