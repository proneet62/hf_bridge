# 📦 Bridge System - インストールガイド

## ⚡ クイックスタート

### 1. ダウンロードとインストール

```bash
# bridgeフォルダをサーバーのresourcesフォルダに配置
[your-server]/resources/bridge/
```

### 2. server.cfg に追加

```cfg
# フレームワーク (どれか1つ)
ensure qb-core
# または
ensure es_extended
# または
ensure qbox

# Bridge System (他のリソースより先に起動)
ensure hf_bridge

# オプション: 推奨リソース
ensure ox_lib
ensure oxmysql
```

### 3. 設定変更 (オプション)

`shared/config.lua` を編集:

```lua
Config.DefaultSettings = {
    notify = "ox",    -- 使用する通知システム
    textui = "jg",    -- 使用するTextUIシステム
}
```

### 4. サーバー再起動

```bash
restart [server-name]
```

---

## 🔧 詳細なセットアップ

### 必須要件

- **FiveM Server** (推奨: 最新版)
- **OneSync** (推奨)
- **フレームワーク** (以下のいずれか):
  - QB-Core
  - ESX (es_extended)
  - QBox
  - または Standalone

### 推奨リソース

#### 1. ox_lib (強く推奨)
```cfg
ensure ox_lib
```
**理由**: 最も多くの機能をサポート (Menu, Input, Progress, Target等)

#### 2. oxmysql
```cfg
ensure oxmysql
```
**理由**: 最新で最速のMySQLライブラリ

#### 3. インベントリシステム (いずれか1つ)
```cfg
ensure ox_inventory
# または
ensure qb-inventory
# または
ensure qs-inventory
```

#### 4. ターゲットシステム (いずれか1つ)
```cfg
ensure ox_target
# または
ensure qb-target
# または
ensure qtarget
```

#### 5. Progress Bar (ox_libを使わない場合)
```cfg
ensure progressbar
# または qb-core / ESX の標準を使用
```

---

## 📋 設定可能なシステム

### 通知システム

`Config.DefaultSettings.notify` で設定:

| 値 | システム | リソース名 |
|---|---|---|
| `"ox"` | ox_lib | ox_lib |
| `"qb"` | QB-Core | qb-core |
| `"esx"` | ESX | es_extended |
| `"okok"` | okokNotify | okokNotify |
| `"ss"` | ss_notify | ss_notify |
| `"standalone"` | フォールバック | なし |

### TextUI システム

`Config.DefaultSettings.textui` で設定:

| 値 | システム | リソース名 |
|---|---|---|
| `"ox"` | ox_lib | ox_lib |
| `"jg"` | jg-textui | jg-textui |
| `"okok"` | okokTextUI | okokTextUI |
| `"ss"` | ss_textui | ss_textui |
| `"qb"` | QB-Core | qb-core |
| `"standalone"` | フォールバック | なし |

---

## 🎯 リソースでの使用方法

### 基本的な使い方

`fxmanifest.lua` に依存関係を追加:

```lua
dependencies {
    'bridge'
}
```

コードで使用:

```lua
-- どこでも使える
local Bridge = exports['hf_bridge']:GetBridge()

-- 初期化を待つ (推奨)
Bridge.WaitForReady()

-- 使用例
if Bridge.FrameworkName == 'qbcore' then
    print('QB-Coreが検出されました')
end
```

### サーバー側の例

```lua
-- server.lua
local Bridge = exports['hf_bridge']:GetBridge()

RegisterNetEvent('myresource:buyItem', function(item, price)
    local source = source
    
    if Bridge.GetMoney(source, 'cash') >= price then
        Bridge.RemoveMoney(source, price, 'cash', 'アイテム購入')
        Bridge.AddItem(source, item, 1)
        TriggerClientEvent('myresource:notify', source, '購入完了', 'success')
    else
        TriggerClientEvent('myresource:notify', source, 'お金が足りません', 'error')
    end
end)
```

### クライアント側の例

```lua
-- client.lua
local Bridge = exports['hf_bridge']:GetBridge()

RegisterNetEvent('myresource:notify', function(message, type)
    Bridge.Notify('通知', message, type)
end)

-- ターゲット追加
Bridge.AddBoxZone({
    name = 'shop',
    coords = vector3(0, 0, 0),
    size = vector3(2.0, 2.0, 2.0),
    options = {
        {
            name = 'open',
            label = 'ショップを開く',
            icon = 'fas fa-store',
            onSelect = function()
                -- ショップを開く
            end
        }
    }
})
```

---

## 🔍 トラブルシューティング

### Bridge が初期化されない

**原因**: フレームワークが検出されていない

**解決策**:
```lua
-- コンソールで確認
print(Bridge.FrameworkName)  -- nil の場合、フレームワークが起動していない
```

### Callback が動作しない

**原因**: server.lua と client.lua が正しく読み込まれていない

**解決策**:
- fxmanifest.lua を確認
- `refresh` コマンドを実行
- サーバーを再起動

### Target が表示されない

**原因**: ターゲットシステムがインストールされていない

**解決策**:
1. ox_target / qb-target / qtarget のいずれかをインストール
2. `ensure ox_target` を server.cfg に追加

### 通知が表示されない

**原因**: 設定されたシステムがインストールされていない

**解決策**:
1. `shared/config.lua` で `notify = "standalone"` に変更
2. または、対応する通知システムをインストール

### インベントリが動作しない

**原因**: インベントリシステムが検出されていない

**解決策**:
```lua
-- コンソールで確認
print(Bridge.Inventory)  -- nil の場合、インベントリが検出されていない
```

---

## 📊 パフォーマンス最適化

### 1. 必要なモジュールのみ読み込む

使わない機能がある場合、fxmanifest.lua から該当行を削除:

```lua
-- 例: Targetを使わない場合
-- 'client/modules/target.lua', ← コメントアウト
```

### 2. ox_lib の使用

ox_lib は最適化されており、複数のシステムを統合できます:

```cfg
ensure ox_lib
```

### 3. リソースの起動順序

```cfg
# 1. データベース
ensure oxmysql

# 2. ライブラリ
ensure ox_lib

# 3. Bridge
ensure hf_bridge

# 4. フレームワーク
ensure qb-core

# 5. その他のリソース
ensure [other-resources]
```

---

## 🆘 サポート

### よくある質問

**Q: QB-CoreとESXを同時に使えますか?**
A: いいえ、1つのフレームワークのみ使用してください。

**Q: スタンドアロンで使えますか?**
A: はい、フレームワークなしでも動作します。

**Q: QBoxに対応していますか?**
A: はい、QBoxはQB-Coreベースなので完全に対応しています。

**Q: カスタムフレームワークで使えますか?**
A: modules/ 内のファイルを編集してカスタマイズできます。

### 問題を報告

バグや問題を発見した場合:

1. GitHub Issues で報告
2. 以下の情報を含めてください:
   - サーバーバージョン
   - フレームワーク
   - エラーメッセージ
   - 再現手順

---

## 🚀 次のステップ

1. **EXAMPLES.lua** で使用例を確認
2. **README.md** で全機能を確認
3. **FEATURES.md** で詳細な説明を確認
4. 実際のリソースで使ってみる

---

## ✅ インストール完了チェックリスト

- [ ] bridgeフォルダを配置
- [ ] server.cfg に `ensure hf_bridge` を追加
- [ ] フレームワークがインストール済み
- [ ] ox_lib をインストール (推奨)
- [ ] インベントリシステムをインストール (推奨)
- [ ] config.lua を設定
- [ ] サーバーを再起動
- [ ] コンソールで `[Bridge] 初期化完了` を確認
- [ ] テストコマンドで動作確認

---

## 🎉 インストール完了!

これでBridge Systemが使えるようになりました。

Happy Coding! 🚀
