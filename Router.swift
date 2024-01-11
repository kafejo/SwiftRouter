//
//  SwiftRouter.swift
//  SwiftRouter
//
//  Created by Ales Kocur on 21.12.2023.
//

import Foundation
import SwiftUI

class SwiftRouter<Route: Routeable>: ObservableObject {
    @Published var path = NavigationPath()

    func popToRoot() {
        path.removeLast(path.count)
    }

    func push(_ item: Route) {
        path.append(item)
    }

    func pop() {
        if path.count > 0 {
            path.removeLast()
        }
    }
}

protocol Routeable: Hashable {
    associatedtype DestinationView: View
    associatedtype Route: Hashable

    @ViewBuilder static func routes(_ route: Route) -> DestinationView
}

struct RouteableNavigationStack<Content: View, Route: Routeable>: View {
    // MARK: Lifecycle

    init(_ routerType: Route.Type, @ViewBuilder content: @escaping (SwiftRouter<Route>) -> Content) {
        self.content = content
    }

    init(_ routerType: Route.Type, @ViewBuilder content: @escaping () -> Content) {
        self.content = { _ in content() }
    }

    // MARK: Internal

    let content: (SwiftRouter<Route>) -> Content

    @StateObject var router = SwiftRouter<Route>()

    var body: some View {
        NavigationStack(path: $router.path) {
            content(router)
                .attachPushRoutes(routes: Route.self)
        }.environmentObject(router)
    }
}

extension View {
    @MainActor
    func attachPushRoutes<Routes: Routeable>(routes: Routes.Type) -> some View {
        navigationDestination(for: Routes.Route.self) { route in
            Routes.routes(route)
        }
    }
}
