//
//  RefreshableScrollView.swift
//  RefreshableScrollView
//
//  Created by Mathijs Bernson on 03/03/2022.
//

import SwiftUI
import UIKit

fileprivate struct RefreshConfig {
    var refreshControl: () -> UIRefreshControl
    var refreshAction: (@Sendable () async -> Void)?
    var loadMoreAction: (@Sendable () async -> Void)?
}

/// A custom scroll view that supports pull to refresh using the `refreshable()` modifier.
public struct RefreshableScrollView<Content: View>: View {
    private var config: RefreshConfig
    @ViewBuilder let content: () -> Content

    public init(
        refreshControl: @autoclosure @escaping () -> UIRefreshControl = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        config = RefreshConfig(refreshControl: refreshControl)
        self.content = content
    }

    public var body: some View {
        GeometryReader { proxy in
            ScrollViewControllerRepresentable(config: config) {
                content()
                    .frame(width: proxy.size.width)
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}

public extension RefreshableScrollView {
    func refreshable(action: @escaping @Sendable () async -> Void) -> Self {
        var view = self
        view.config.refreshAction = action
        return view
    }

    func footerLoadMore(action: @escaping @Sendable () async -> Void) -> Self {
        var view = self
        view.config.loadMoreAction = action
        return view
    }
}

private struct ScrollViewControllerRepresentable<Content: View>: UIViewControllerRepresentable {
    @ViewBuilder let content: () -> Content
    let config: RefreshConfig

    init(config: RefreshConfig, @ViewBuilder content: @escaping () -> Content) {
        self.config = config
        self.content = content
    }

    func makeUIViewController(context: Context) -> ScrollViewController<Content> {
        let viewController = ScrollViewController<Content>(
            refreshControl: config.refreshControl()
        )
        viewController.onRefresh = { [unowned viewController] in
            refresh(viewController)
        }
        viewController.onLoadMore = { [unowned viewController] in
            loadMore(viewController)
        }
        return viewController
    }

    func updateUIViewController(_ viewController: ScrollViewController<Content>, context: Context) {
        viewController.hostingController.rootView = content()
        viewController.hostingController.view.setNeedsUpdateConstraints()
    }

    func refresh(_ viewController: ScrollViewController<Content>) {
        guard !viewController.isRefreshing else {
            return
        }
        Task { @MainActor [weak viewController] in
            guard let viewController = viewController else { return }
            viewController.isRefreshing = true
            defer { viewController.isRefreshing = false }

            viewController.refreshControl.beginRefreshing()
            try? await Task.sleep(nanoseconds: 350 * 1000000)
            await config.refreshAction?()
            viewController.refreshControl.endRefreshing()
        }
    }

    func loadMore(_ viewController: ScrollViewController<Content>) {
        guard !viewController.isRefreshing, !viewController.isLoadMore else {
            return
        }
        Task { @MainActor [weak viewController] in
            guard let viewController = viewController else { return }
            viewController.isLoadMore = true
            defer { viewController.isLoadMore = false }
            await config.loadMoreAction?()
        }
    }
}

class ScrollViewController<Content: View>: UIViewController, UIScrollViewDelegate {
    let scrollView = UIScrollView()
    let refreshControl: UIRefreshControl
    let hostingController: UIHostingController<Content?>
    var onRefresh: (() -> Void)?
    var onLoadMore: (() -> Void)?

    var isRefreshing: Bool = false
    var isLoadMore: Bool = false

    init(refreshControl: UIRefreshControl) {
        self.refreshControl = refreshControl
        hostingController = UIHostingController<Content?>(rootView: nil)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = scrollView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)

        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.refreshControl = refreshControl
        scrollView.delegate = self

        hostingController.willMove(toParent: self)

        scrollView.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])

        // `addChild` must be called *after* the layout constraints have been set, or a layout bug will occur
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        hostingController.view.backgroundColor = .clear
    }

    @objc func didPullToRefresh(_: UIRefreshControl) {
        onRefresh?()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isBouncingBottom {
            onLoadMore?()
        }
    }
}

private extension UIScrollView {
    var isBouncingBottom: Bool {
        let threshold: CGFloat = if contentSize.height > frame.size.height {
            contentSize.height - frame.size.height + contentInset.bottom + bottomInsetForBouncing
        } else {
            topInsetForBouncing
        }
        return contentOffset.y > threshold
    }

    private var topInsetForBouncing: CGFloat {
        safeAreaInsets.top != 0.0 ? -safeAreaInsets.top : 0.0
    }

    private var bottomInsetForBouncing: CGFloat {
        safeAreaInsets.bottom
    }
}
