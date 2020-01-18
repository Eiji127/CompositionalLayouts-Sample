//
//  SectionType.swift
//  CompositionalLayouts-Sample
//
//  Created by kawaharadai on 2020/01/18.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

// NSCollectionLayoutSection毎の種別
enum SectionType {
    case grid // グリッド表示されるセクション
    case largeAndSmallSquare // 大小2種類の正方形で構成されるセクション(インスタ風)
    case verticalRectangle // 縦の長方形１つのみのセクション
    case rectangleHorizonContinuousWithHeader // 縦の長方形が横スクロールで流れていくセクション（ヘッダー付き）
    case squareWithHeader // 正方形が1つのみのセクション（ヘッダー付き）

    init?(section: Int, type: LayoutType) {
        switch (section, type) {
        case (0, .grid):
            self = .grid
        case (0, .insta):
            self = .largeAndSmallSquare
        case (0, .netflix):
            self = .verticalRectangle
        case (1, .netflix):
            self = .rectangleHorizonContinuousWithHeader
        case (2, .netflix):
            self = .rectangleHorizonContinuousWithHeader
        case (3, .netflix):
            self = .squareWithHeader
        default: return nil
        }
    }

    func section(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        switch self {
        case .grid:
            return gridSection(collectionViewBounds: collectionViewBounds)
        case .largeAndSmallSquare:
            return largeAndSmallSquareSection(collectionViewBounds: collectionViewBounds)
        case .verticalRectangle:
            return verticalRectangleSection(collectionViewBounds: collectionViewBounds)
        case .rectangleHorizonContinuousWithHeader:
            return rectangleHorizonContinuousWithHeaderSection(collectionViewBounds: collectionViewBounds)
        case .squareWithHeader:
            return squareWithHeaderSection(collectionViewBounds: collectionViewBounds)
        }
    }

    /// グリッド表示
    private func gridSection(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        let itemCount = 3 // 横に並べる数
        let lineCount = itemCount - 1
        let itemSpacing = CGFloat(2) // セル間のスペース
        let itemLength = (collectionViewBounds.width - (itemSpacing * CGFloat(lineCount))) / CGFloat(itemCount)
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(itemLength),
                                                                             heightDimension: .absolute(itemLength)))
        let items = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                          heightDimension: .fractionalHeight(1.0)),
                                                       subitem: item,
                                                       count: itemCount)
        items.interItemSpacing = .fixed(itemSpacing)
        let groups = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                         heightDimension: .absolute(itemLength)),
                                                      subitems: [items])
        let section = NSCollectionLayoutSection(group: groups) // ここでセルの数に反映
        section.interGroupSpacing = itemSpacing
        section.contentInsets = .init(top: 0, leading: itemSpacing, bottom: 0, trailing: itemSpacing)
        return section
    }

    /// (大+小縦2)+(小縦2*横3)+(小縦2+大)+(小縦2*横3)の計18アイテム
    private func largeAndSmallSquareSection(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        let itemSpacing = CGFloat(2) // セル間のスペース
        // 小ブロック縦2グループ
        let itemLength = (collectionViewBounds.width - (itemSpacing * 2)) / 3
        let largeItemLength = itemLength * 2 + itemSpacing

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(itemLength),
                                                                             heightDimension: .absolute(itemLength)))
        let verticalItemTwo = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(itemLength),
                                                                                                  heightDimension: .absolute(largeItemLength)),
                                                               subitem: item,
                                                               count: 2)
        verticalItemTwo.interItemSpacing = .fixed(itemSpacing)
        // 大ブロックありグループ
        let largeItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(largeItemLength),
                                                                                  heightDimension: .absolute(largeItemLength)))

        let largeItemLeftGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                       heightDimension: .absolute(largeItemLength)),
                                                                    subitems: [largeItem, verticalItemTwo])
        largeItemLeftGroup.interItemSpacing = .fixed(itemSpacing)

        let largeItemRightGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                        heightDimension: .absolute(largeItemLength)),
                                                                     subitems: [verticalItemTwo, largeItem])
        largeItemRightGroup.interItemSpacing = .fixed(itemSpacing)
        // 小ブロック縦2横3グループ
        let twoThreeItemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                      heightDimension: .absolute(largeItemLength)),
                                                                   subitem: verticalItemTwo,
                                                                   count: 3)
        twoThreeItemGroup.interItemSpacing = .fixed(itemSpacing)

        let subitems = [largeItemLeftGroup, twoThreeItemGroup, largeItemRightGroup, twoThreeItemGroup]
        let groupsSpaceCount = CGFloat(subitems.count - 1)
        let heightDimension = NSCollectionLayoutDimension.absolute(largeItemLength * CGFloat(subitems.count) + (itemSpacing * groupsSpaceCount))
        // MEMO: 高さの計算は後に追加するスペース分も足す
        let groups = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                         heightDimension: heightDimension),
                                                      subitems: subitems)
        groups.interItemSpacing = .fixed(itemSpacing)
        let section = NSCollectionLayoutSection(group: groups)
        section.interGroupSpacing = itemSpacing
        return section
    }

    /// 縦長の長方形が１つだけ
    private func verticalRectangleSection(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        let verticalRectangleHeight = collectionViewBounds.height * 0.8
        let verticalRectangleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                              heightDimension: .fractionalHeight(1.0)))
        let verticalRectangleGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                         heightDimension: .absolute(verticalRectangleHeight)),
                                                                      subitem: verticalRectangleItem,
                                                                      count: 1)
        return NSCollectionLayoutSection(group: verticalRectangleGroup)
    }

    /// 縦長の長方形が横スクロールする（ヘッダー付き）
    private func rectangleHorizonContinuousWithHeaderSection(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        let headerHeight = CGFloat(50)
        let headerElementKind = "header-element-kind"
        let rectangleItemHeight = collectionViewBounds.width * 0.9 / 3 * (4/3)
        let rectangleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                      heightDimension: .fractionalHeight(1.0)))
        let horizonRectangleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(rectangleItemHeight)), subitem: rectangleItem,
                                                                       count: 1)
        let horizonRectangleContinuousSection = NSCollectionLayoutSection(group: horizonRectangleGroup)
        let sectionHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(headerHeight)),
            elementKind: headerElementKind,
            alignment: .top)
        horizonRectangleContinuousSection.boundarySupplementaryItems = [sectionHeaderItem]
        horizonRectangleContinuousSection.orthogonalScrollingBehavior = .continuous
        return horizonRectangleContinuousSection
    }

    /// 正方形が1つだけ（ヘッダー付き）
    private func squareWithHeaderSection(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        let itemLength = collectionViewBounds.width
        let headerHeight = CGFloat(50)
        let headerElementKind = "header-element-kind"
        let squareItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let squareGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                              heightDimension: .absolute(itemLength)),
                                                           subitem: squareItem,
                                                           count: 1)
        let squareSection = NSCollectionLayoutSection(group: squareGroup)
        let sectionHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(headerHeight)),
            elementKind: headerElementKind,
            alignment: .top)
        squareSection.boundarySupplementaryItems = [sectionHeaderItem]
        return squareSection
    }
}
