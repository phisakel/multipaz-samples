//
//  ZkpExtensions.swift
//  MpzSwiftWallet
//
//  Created by PHILIP SAKELLAROPOULOS on 1/17/26.
import Foundation
import Multipaz
import os.log

let logger = Logger(subsystem: "ZkSystem", category: "LongFellow")

extension ZkSystemRepository {
    /// Enumerates filenames and file URLs in the longfellow-libzk-v1 folder in the app bundle.
    /// - Returns: Array of (filename, fileURL) tuples for each file in the folder.
    public static func enumerateLongfellowCircuits() throws -> ZkSystemRepository {
        let res = ZkSystemRepository()
        let lf = LongfellowZkSystem()
        let folderURL = Bundle.main.resourceURL!
        let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter { $0.pathExtension.isEmpty }
        for url in fileURLs {
            let name = url.lastPathComponent
            guard name.split(separator: "_").count == 5 else { continue }
            guard let circuitBytes: Data = try? Data(contentsOf: url) else { continue }
            let bs = circuitBytes.toByteString()
            lf.addCircuit(circuitFilename: name, circuitBytes: bs)
        }
        // test generate proof
        // let zkSystemSpec = lf.systemSpecs.first!; let docBs = Data(MdocTestData.getMdocBytes()).toByteString(); let stBs = Data(MdocTestData.getTranscript()).toByteString()
        // let zkDoc = lf.generateProof(zkSystemSpec: zkSystemSpec, encodedDocument: docBs, encodedSessionTranscript: stBs, timestamp: Date.now.toKotlinInstant().truncateToWholeSeconds())
        return res.add(zkSystem: lf)
    }
}
