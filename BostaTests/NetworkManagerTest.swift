//
//  NetworkManagerTest.swift
//  BostaTests
//
//  Created by MacBook on 16/09/2025.
//

import XCTest
import Moya
import RxSwift
@testable import bostaDemo 

final class NetworkManagerTest: XCTestCase {

    private var bag = DisposeBag()
    
    private func makeStubProvider(
        responder: @escaping (JSONPlaceholder) -> (status: Int, data: Data)
    ) -> MoyaProvider<JSONPlaceholder> {

        let endpoint = { (target: JSONPlaceholder) -> Endpoint in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            let res = responder(target)
            return Endpoint(
                url: url,
                sampleResponseClosure: { .networkResponse(res.status, res.data) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }

        return MoyaProvider<JSONPlaceholder>(
            endpointClosure: endpoint,
            stubClosure: MoyaProvider.immediatelyStub
        )
    }

    func test_fetchUsers_serviceStyle_success() {
        let exp = expectation(description: "fetch users")
        let usersJSON = Data("""
        [{
          "id": 1,
          "name": "Leanne Graham",
          "address": {
            "street": "Kulas Light",
            "suite": "Apt. 556",
            "city": "Gwenborough",
            "zipcode": "92998-3874"
          }
        }]
        """.utf8)

        let provider = makeStubProvider { target in
            switch target {
            case .users: return (200, usersJSON)
            default: preconditionFailure("Unexpected target: \(target)")
            }
        }
        let api = NetworkManager(provider: provider)

        api.fetchUsers()
            .subscribe(onSuccess: { users in
                // Assert
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users.first?.name, "Leanne Graham")
                XCTAssertEqual(users.first?.address.city, "Gwenborough")
                exp.fulfill()
            }, onFailure: { error in
                XCTFail("Unexpected error: \(error)")
                exp.fulfill()
            })
            .disposed(by: bag)

        waitForExpectations(timeout: 0.1)
    }

    func test_fetchAlbums_serviceStyle_paramAndDecode() {
        let exp = expectation(description: "fetch albums")

        let albumsJSON = Data("""
        [{ "userId": 7, "id": 10, "title": "Summer 2025" }]
        """.utf8)

        let provider = makeStubProvider { target in
            switch target {
            case .albums(let userId):
                XCTAssertEqual(userId, 7)
                return (200, albumsJSON)
            default:
                preconditionFailure("Unexpected target: \(target)")
            }
        }
        let api = NetworkManager(provider: provider)

        api.fetchAlbums(for: 7)
            .subscribe(onSuccess: { albums in
                XCTAssertEqual(albums.count, 1)
                XCTAssertEqual(albums.first?.title, "Summer 2025")
                exp.fulfill()
            }, onFailure: { error in
                XCTFail("Unexpected error: \(error)")
                exp.fulfill()
            })
            .disposed(by: bag)

        waitForExpectations(timeout: 0.1)
    }

    func test_fetchUsers_serviceStyle_httpError() {
        let exp = expectation(description: "fetch users error")
        let provider = makeStubProvider { target in
            switch target {
            case .users: return (500, Data())
            default: preconditionFailure("Unexpected target: \(target)")
            }
        }
        let api = NetworkManager(provider: provider)

        api.fetchUsers()
            .subscribe(onSuccess: { _ in
                XCTFail("Expected error, got success")
                exp.fulfill()
            }, onFailure: { _ in
                exp.fulfill()
            })
            .disposed(by: bag)

        waitForExpectations(timeout: 0.1)
    }

    func test_fetchUsers_serviceStyle_decodingError() {
        let exp = expectation(description: "fetch users decoding error")
        let invalid = Data(#"[{ "id": 1, "name": "X", "address": {} }]"#.utf8)

        let provider = makeStubProvider { target in
            switch target {
            case .users: return (200, invalid)
            default: preconditionFailure("Unexpected target: \(target)")
            }
        }
        let api = NetworkManager(provider: provider)

        api.fetchUsers()
            .subscribe(onSuccess: { _ in
                XCTFail("Expected decoding error")
                exp.fulfill()
            }, onFailure: { _ in
                exp.fulfill()
            })
            .disposed(by: bag)

        waitForExpectations(timeout: 0.1)
    }
}

