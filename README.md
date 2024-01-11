# SwiftRouter

A convenience wrapper for NavigationStack.

# Motivation

NavigationStack can be a bit verbose and hard to reuse. This wrapper makes it easier to setup navigation in your SwiftUI app. It also makes it easier to reuse navigation logic for example in Previews.

# Usage

Create definition of your routes and conform it to `Routeable`

```swift
enum MyRoutes {
    case login
    case signup
    case resetPassword(email: String)
}

extension MyRoutes: Routeable {
    @ViewBuilder
    static func routes(_ route: MyRoutes) -> some View {
        // Replace with your actual views. For the sake of this example we just use Text.
        switch route {
        case .login:
            Text("Login")
        case .signup:
            Text("Signup")
        case .resetPassword(email: let email):
            Text("Email: \(email)")
        }
    }
}
```

Now instead of creating `NavigationStack` directly you can use `RouteableNavigationStack` and pass your routes type. This will create `NavigationStack` with the router, attaches the navigation destinations and passes the router into the environment.

```swift
struct MyRootView: View {
    var body: some View {
        RouteableNavigationStack(MyRoutes.self) { router in
            Button("Push") {
                router.push(.login)
            }
        }
    }
}
```

You can access the router via environment object `Router<MyRoutes>` in all your subviews.

```swift
struct MyRootView: View {
    var body: some View {
        RouteableNavigationStack(MyRoutes.self) { _ in
            ContentView()
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var router: SwiftRouter<MyRoutes>

    var body: some View {
        Button("Push") {
            router.push(.login)
        }
    }
}
```

## Previews

You can also use `RouteableNavigationStack` in your previews. This makes it easier to preview your navigation logic.

```swift
#Preview {
    RouteableNavigationStack(MyRoutes.self) { router in
        ContentView()
    }
}
```
