// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {
    // カウントの値を保持する変数
    int256 private count;

    // コンストラクタで初期値を設定
    constructor(int256 _initialCount) {
        count = _initialCount;
    }

    // カウントをインクリメントする関数
    function increment() public {
        count += 1;
    }

    // カウントをデクリメントする関数
    function decrement() public {
        count -= 1;
    }

    // 現在のカウント値を取得する関数
    function getCount() public view returns (int256) {
        return count;
    }

    // カウント値をリセットする関数（任意）
    function resetCount(int256 _newCount) public {
        count = _newCount;
    }
}
