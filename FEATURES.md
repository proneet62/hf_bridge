# 追加された機能一覧

既存のBridgeシステムに以下の機能を追加しました。

## 📋 新規追加モジュール

### 1. **Callback System** (`callback.lua`)
サーバーとクライアント間の双方向通信を簡単に実装できるシステム

**機能:**
- サーバー→クライアント Callback
- クライアント→サーバー Callback
- 非同期通信の簡単な実装

**使用例:**
```lua
-- Server側
Bridge.RegisterCallback('getData', function(source, cb, arg)
    cb({result = arg * 2})
end)

-- Client側
Bridge.TriggerCallback('getData', function(data)
    print(data.result) -- 10
end, 5)
```

---

### 2. **Target System** (`target.lua`)
ox_target、qb-target、qtarget に対応した統合ターゲットシステム

**機能:**
- エンティティターゲット
- モデルターゲット
- ボックスゾーン
- グローバルプレイヤー/車両ターゲット

**使用例:**
```lua
Bridge.AddTargetModel('prop_atm_01', {
    {
        name = 'use_atm',
        label = 'ATMを使う',
        icon = 'fas fa-credit-card',
        onSelect = function()
            -- ATM処理
        end
    }
})
```

---

### 3. **Progress Bar** (`progressbar.lua`)
各種プログレスバーシステムに対応

**対応システム:**
- ox_lib
- progressbar
- qb-core
- esx_progressbar

**機能:**
- アニメーション対応
- Prop (小道具) 表示
- キャンセル機能
- 移動/戦闘無効化

**使用例:**
```lua
local success = Bridge.ShowProgress({
    duration = 5000,
    label = '修理中...',
    animation = {
        dict = 'mini@repair',
        anim = 'fixing_a_player'
    }
})
```

---

### 4. **Input & Menu System** (`input.lua`)
入力ダイアログとコンテキストメニューの統合

**機能:**
- 入力ダイアログ (テキスト、数値、選択など)
- コンテキストメニュー
- 確認ダイアログ
- スキルチェック

**対応システム:**
- ox_lib
- qb-input / qb-menu
- nh-context
- ps-ui (skillcheck)

**使用例:**
```lua
local input = Bridge.ShowInput({
    header = '情報入力',
    inputs = {
        {name = 'name', label = '名前', type = 'text', required = true},
        {name = 'age', label = '年齢', type = 'number'}
    }
})
```

---

### 5. **Stash/Storage System** (`stash.lua`)
インベントリのストレージ管理

**機能:**
- スタッシュ登録
- スタッシュ開閉
- トランク管理
- グローブボックス管理
- スタッシュ内容取得
- スタッシュクリア

**使用例:**
```lua
-- Server
Bridge.RegisterStash('police_evidence', {
    label = '証拠品保管庫',
    slots = 100,
    weight = 500000
})

Bridge.OpenStash(source, 'police_evidence')
```

---

### 6. **Vehicle Keys System** (`vehicle_extras.lua`)
車両キーの統合管理

**対応システム:**
- qb-vehiclekeys
- qs-vehiclekeys
- cd_garage
- wasabi_carlock

**機能:**
- キー付与
- キー削除
- キー所持確認

**使用例:**
```lua
-- Server
Bridge.GiveVehicleKeys(source, plate)

-- Client
if Bridge.HasVehicleKeys(plate) then
    -- キーを持っている
end
```

---

### 7. **Fuel System** (`vehicle_extras.lua`)
各種燃料システムの統合

**対応システム:**
- LegacyFuel
- ox_fuel
- ps-fuel
- cdn-fuel
- qs-fuelstations

**機能:**
- 燃料取得
- 燃料設定

**使用例:**
```lua
local fuel = Bridge.GetVehicleFuel(vehicle)
Bridge.SetVehicleFuel(vehicle, 75.0)
```

---

### 8. **Society & Gang Money** (`society.lua`)
会社とギャングの資金管理

**機能:**
- ソサエティ(会社)資金の取得/追加/削除
- ギャング資金の管理 (QB-Core)
- 銀行送金
- オフライン入金

**使用例:**
```lua
-- ソサエティ資金取得
Bridge.GetSocietyMoney('police', function(money)
    print('警察の資金: $' .. money)
end)

-- 資金追加
Bridge.AddSocietyMoney('police', 10000)

-- プレイヤー間送金
Bridge.TransferMoney(source, target, 1000, '送金')
```

---

## 🔄 既存機能の改善

### Logger Module
**追加機能:**
- より詳細なDiscord Embed対応
- カラーコード対応 (0xRRGGBB / #RRGGBB)
- プレイヤーアクションログ専用関数
- フィールド形式のログ

### Utils Module
**追加関数:**
- Try-Catch-Finally パターン
- SafeCall (pcall wrapper)
- テーブル操作 (DeepCopy, TableContains, GetTableKeys)
- 文字列操作 (SplitString, Trim, Capitalize)
- 数値操作 (Clamp, Round, Random)
- 時間変換 (MsToTime, FormatTime)
- 数学関数 (Lerp, GetAngleBetweenPoints)

---

## 📦 フォルダ構造

```
bridge/
├── fxmanifest.lua          # マニフェストファイル
├── README.md               # メインドキュメント
├── EXAMPLES.lua            # 使用例サンプル
├── shared/                 # 共有ファイル
│   ├── config.lua         # 設定
│   ├── main.lua           # メイン初期化
│   └── utils.lua          # ユーティリティ関数
├── server/                 # サーバー側
│   ├── main.lua
│   └── modules/
│       ├── callback.lua       # ✨ NEW
│       ├── player.lua
│       ├── money.lua
│       ├── inventory.lua
│       ├── logger.lua         # 強化版
│       ├── stash.lua          # ✨ NEW
│       ├── society.lua        # ✨ NEW
│       └── vehicle_extras.lua # ✨ NEW
└── client/                 # クライアント側
    ├── main.lua
    └── modules/
        ├── callback.lua       # ✨ NEW
        ├── notify.lua
        ├── vehicles.lua
        ├── draw.lua
        ├── utils.lua
        ├── target.lua         # ✨ NEW
        ├── progressbar.lua    # ✨ NEW
        ├── input.lua          # ✨ NEW
        ├── stash.lua          # ✨ NEW
        └── vehicle_extras.lua # ✨ NEW
```

---

## 🎯 主な改善点

1. **完全なモジュール化**: 各機能が独立したモジュールとして実装
2. **マルチシステム対応**: 主要なFiveMリソースに幅広く対応
3. **エラーハンドリング**: Try-Catch パターンなどの安全な実装
4. **使いやすいAPI**: 統一されたインターフェース
5. **詳細なドキュメント**: README と EXAMPLES.lua で完全サポート

---

## 🚀 次のステップ

### 推奨される追加機能:

1. **Clothing System**
   - qb-clothing, illenium-appearance, fivem-appearance対応
   
2. **Housing System**
   - qb-houses, qs-housing連携
   
3. **Phone System**
   - qb-phone, qs-smartphone連携
   
4. **Dispatch System**
   - cd_dispatch, ps-dispatch, qs-dispatch対応
   
5. **Multicharacter System**
   - キャラクター選択画面の統合
   
6. **Banking System**
   - qb-banking, okokBanking, Renewed-Banking対応
   
7. **Crafting System**
   - クラフトシステムの統合
   
8. **Minigames**
   - 各種ミニゲームの統合API

---

## 📝 使い方のヒント

### 開発者向け

1. **リソースでBridgeを使用**:
```lua
local Bridge = exports['hf_bridge']:GetBridge()
Bridge.WaitForReady()
```

2. **フレームワーク検出**:
```lua
if Bridge.FrameworkName == 'qbcore' then
    -- QB-Core専用処理
elseif Bridge.FrameworkName == 'esx' then
    -- ESX専用処理
end
```

3. **安全な実装**:
```lua
Bridge.Try(function()
    -- 実行したいコード
end).catch(function(err)
    print('エラー: ' .. err)
end)
```

### サーバーオーナー向け

1. `shared/config.lua` で使用するシステムを設定
2. 必要なリソースをインストール
3. `ensure hf_bridge` をserver.cfgに追加

---

## ⚠️ 重要な注意事項

- ox_lib の使用を強く推奨 (最も機能が豊富)
- MySQL.Async は非推奨 (oxmysql を使用)
- 各システムの最新版を使用してください
- カスタマイズする場合は、modules/ 内のファイルを編集

---

## 🤝 コミュニティ

バグ報告や機能リクエストは GitHub Issues でお願いします。

このブリッジシステムがあなたのFiveMサーバー開発を加速させることを願っています! 🚀
