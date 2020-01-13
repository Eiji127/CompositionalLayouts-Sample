//
//  LayoutType.swift
//  CompositionalLayouts-Sample
//
//  Created by kawaharadai on 2020/01/06.
//  Copyright © 2020 kawaharadai. All rights reserved.
//

import UIKit

enum LayoutType {
    case grid // グリッド形式での表示（3 * n）
    case insta
    case pintarest

    func layout(collectionViewBounds: CGRect) -> UICollectionViewLayout {
        switch self {
        case .grid:
            let itemLength = NSCollectionLayoutDimension.absolute(collectionViewBounds.width / 3)
            let itemSpacing = CGFloat(2)
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: itemLength, heightDimension: itemLength))
            let items = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                              heightDimension: .fractionalHeight(1.0)),
                                                           subitem: item,
                                                           count: 3)
            items.interItemSpacing = .fixed(itemSpacing)
            let groups = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                             heightDimension: itemLength),
                                                          subitems: [items])
            let sections = NSCollectionLayoutSection(group: groups) // ここでセルの数に反映
            sections.interGroupSpacing = itemSpacing
            sections.contentInsets = .init(top: 0, leading: itemSpacing, bottom: 0, trailing: itemSpacing)
            let layout = UICollectionViewCompositionalLayout(section: sections)
            return layout
        case .insta:
            // セル間のスペース
            let itemSpacing = CGFloat(2)

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
            let sections = NSCollectionLayoutSection(group: groups)
            sections.interGroupSpacing = itemSpacing
            let layout = UICollectionViewCompositionalLayout(section: sections)
            return layout
        default: return UICollectionViewLayout()
        }
    }
}
