//
//  RDP.swift
//  rdp-ios
//
//  Created by space on 2022/3/7.
//

import Foundation

enum RDPError: Error {
    case unknown
    case utf8
    case closed
}

func get_rdp_error(result: RESULT) -> RDPError {
    switch result {
    case RESULT_ERR_UNKNOWN:
        return RDPError.unknown
    case RESULT_ERR_UTF8:
        return RDPError.utf8
    case RESULT_ERR_CLOSED:
        return RDPError.closed
    default:
        return RDPError.unknown
    }
}

class RDPWrapper {
    var inner: UnsafeMutablePointer<RDP?>
    
    static func setup_stdout_logger(){
        rdp_setup_stdout_logger()
    }
    init(config: String) throws {
        let pointer = UnsafeMutablePointer<RDP?>.allocate(capacity: 1)
        let result = rdp_run(pointer, config)
        
        guard result == RESULT_OK else {
            pointer.deallocate()
            throw get_rdp_error(result: result)
        }
        
        self.inner = pointer
    }
    deinit {
        rdp_stop(self.inner)

        self.inner.deallocate()
    }
    
    func update_config(config: String) throws {
        rdp_update_config(self.inner.pointee, config)
    }
}
