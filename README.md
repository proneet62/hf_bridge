# hf_bridge

このリソースは、現在の Qbox / QB-Core 系リソースから利用する共通 Bridge です。フレームワーク、インベントリ、通知、UI、Target、車両、コールバックなどの呼び出しを `GetBridge()` に集約します。

## 起動

`server.cfg` では依存リソースより先に起動してください。

```cfg
ensure ox_lib
ensure oxmysql
ensure qb-core
ensure hf_bridge
```

実際の構成に合わせて `qb-core`、インベントリ、Target などを起動してください。manifest の必須依存関係は `ox_lib`、`oxmysql`、`qb-core`、OneSync、FXServer 5848 以上です。

## 利用方法

```lua
local Bridge = exports['hf_bridge']:GetBridge()
Bridge.WaitForReady()
```

`GetBridge` は client / server の両方で利用できます。実装は `shared/`、`client/modules/`、`server/modules/` に分割されています。

## 現行 API

### Server

```lua
local Player = Bridge.GetPlayer(source)
local name = Bridge.GetPlayerName(source)
local identifier = Bridge.GetIdentifier(source)
local job, grade = Bridge.GetJob(source)
local money = Bridge.GetMoney(source, 'cash')

Bridge.AddMoney(source, 1000, 'cash', 'reward')
Bridge.RemoveMoney(source, 500, 'bank', 'purchase')
Bridge.AddItem(source, 'water', 1)
Bridge.RemoveItem(source, 'bread', 1)
local hasItem = Bridge.HasItem(source, 'tablet', 1)
```

主な Server API:

- Player: `GetPlayer`、`GetIdentifier`、`GetLicense`、`GetPlayerName`、`GetJob`、`HasJob`、`GetGang`、`DoesPlayerExist`、`GetPlayers`、`IsAdmin`
- Money: `GetMoney`、`AddMoney`、`RemoveMoney`、`TransferMoney`
- Inventory: `AddItem`、`RemoveItem`、`HasItem`、`GetItem`、`GetItemCount`、`CanCarryItem`、重量 / 空きスロット取得
- Stash: `RegisterStash`、`OpenStash`、`GetStashItems`、`ClearStash`、`OpenTrunk`、`OpenGlovebox`
- Society: society / gang / bank の取得・入出金・送金
- Vehicle keys: `GiveVehicleKeys`、`RemoveVehicleKeys`、`HasVehicleKeys`
- Logger: `Log`、`SendWebhook`、`SendDiscordLog`、`LogPlayerAction`
- Callback: `RegisterCallback`、`TriggerClientCallback`

### Client

```lua
Bridge.Notify('通知', '処理が完了しました', 'success', 5000)
Bridge.ShowTextUI('[E] 使用する', 'right')
Bridge.HideTextUI()

Bridge.TriggerCallback('my_resource:getData', function(data)
    print(data.value)
end)
```

主な Client API:

- Callback: `TriggerCallback`、`RegisterClientCallback`
- UI: `Notify`、`ShowTextUI`、`HideTextUI`、`ShowInput`、`ShowMenu`、`CloseMenu`、`ShowConfirm`、`ShowSkillCheck`
- Progress: `ShowProgress`、`CancelProgress`、`IsProgressActive`
- Inventory: `GetItemCount`、`HasItem`、`GetInventory`、`GetItem`
- Target: entity / model / zone / global の追加・削除
- Vehicle: `SpawnVehicle`、`DeleteVehicle`、`GetPlayerVehicle`、`GetClosestVehicle`、燃料・キー API
- Utility: `DrawText3D`、`DrawMarker`、`IsPlayerNearby`、`IsControlPressed`、`ShowHelpText`

## 設定

`shared/config.lua` の `Config.DefaultSettings` で既定の provider を設定します。現在のサーバー構成では、通知・TextUI・各種 UI は `hf` または `ox`、車両キーは `qb`、燃料は `cdn`、Progress は `ox` が設定されています。

フレームワークとインベントリは起動中リソースから自動検出します。検出値は `Bridge.FrameworkName` と `Bridge.Inventory` で確認できます。

## ファイル構成

```text
hf_bridge/
├─ fxmanifest.lua
├─ shared/
│  ├─ config.lua
│  ├─ locales.lua
│  ├─ main.lua
│  └─ utils.lua
├─ client/modules/
└─ server/modules/
```

`client/main.lua` と `server/main.lua` は `shared/main.lua` の `GetBridge` export と重複する空ファイルだったため削除しました。実行時モジュールは manifest から直接読み込みます。

## 互換性について

resource 名は `hf_bridge` です。利用側は次の形を維持してください。

```lua
exports['hf_bridge']:GetBridge()
```

Bridge 内部の API 名やイベントを直接置き換えず、利用側リソースの既存呼び出しを壊さない方針です。

## ライセンス

MIT License
