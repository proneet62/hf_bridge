--=========================================================================================================
--                                    LOCALES SYSTEM (多言語対応)
--=========================================================================================================

Locales = {}

--=========================================================================================================
--                                    日本語 (Japanese)
--=========================================================================================================
Locales['ja'] = {
    -- 一般
    ['success'] = '成功しました',
    ['error'] = 'エラーが発生しました',
    ['warning'] = '警告',
    ['info'] = '情報',
    ['confirm'] = '確認',
    ['cancel'] = 'キャンセル',
    ['close'] = '閉じる',
    ['save'] = '保存',
    ['delete'] = '削除',
    ['edit'] = '編集',
    ['loading'] = '読み込み中...',
    
    -- お金関連
    ['not_enough_money'] = 'お金が足りません',
    ['money_added'] = '$%s を受け取りました',
    ['money_removed'] = '$%s を支払いました',
    ['transfer_success'] = '$%s を送金しました',
    ['transfer_failed'] = '送金に失敗しました',
    
    -- インベントリ
    ['item_added'] = '%s x%s を受け取りました',
    ['item_removed'] = '%s x%s を失いました',
    ['inventory_full'] = 'インベントリがいっぱいです',
    ['item_not_found'] = 'アイテムが見つかりません',
    
    -- 車両
    ['vehicle_spawned'] = '車両をスポーンしました',
    ['vehicle_deleted'] = '車両を削除しました',
    ['no_vehicle_nearby'] = '近くに車両がありません',
    ['keys_received'] = '車両キーを受け取りました',
    ['keys_removed'] = '車両キーを失いました',
    ['not_in_vehicle'] = '車両に乗っていません',
    
    -- ジョブ
    ['no_permission'] = '権限がありません',
    ['job_required'] = 'このジョブが必要です: %s',
    
    -- プログレス
    ['action_cancelled'] = 'アクションがキャンセルされました',
    ['action_completed'] = 'アクションが完了しました',
    
    -- ショップ
    ['shop_buy'] = '購入',
    ['shop_sell'] = '売却',
    ['purchase_success'] = '購入完了',
    ['purchase_failed'] = '購入に失敗しました',
}

--=========================================================================================================
--                                    英語 (English)
--=========================================================================================================
Locales['en'] = {
    -- General
    ['success'] = 'Success',
    ['error'] = 'An error occurred',
    ['warning'] = 'Warning',
    ['info'] = 'Information',
    ['confirm'] = 'Confirm',
    ['cancel'] = 'Cancel',
    ['close'] = 'Close',
    ['save'] = 'Save',
    ['delete'] = 'Delete',
    ['edit'] = 'Edit',
    ['loading'] = 'Loading...',
    
    -- Money
    ['not_enough_money'] = 'Not enough money',
    ['money_added'] = 'Received $%s',
    ['money_removed'] = 'Paid $%s',
    ['transfer_success'] = 'Transferred $%s',
    ['transfer_failed'] = 'Transfer failed',
    
    -- Inventory
    ['item_added'] = 'Received %s x%s',
    ['item_removed'] = 'Lost %s x%s',
    ['inventory_full'] = 'Inventory is full',
    ['item_not_found'] = 'Item not found',
    
    -- Vehicle
    ['vehicle_spawned'] = 'Vehicle spawned',
    ['vehicle_deleted'] = 'Vehicle deleted',
    ['no_vehicle_nearby'] = 'No vehicle nearby',
    ['keys_received'] = 'Received vehicle keys',
    ['keys_removed'] = 'Lost vehicle keys',
    ['not_in_vehicle'] = 'Not in a vehicle',
    
    -- Job
    ['no_permission'] = 'No permission',
    ['job_required'] = 'Required job: %s',
    
    -- Progress
    ['action_cancelled'] = 'Action cancelled',
    ['action_completed'] = 'Action completed',
    
    -- Shop
    ['shop_buy'] = 'Buy',
    ['shop_sell'] = 'Sell',
    ['purchase_success'] = 'Purchase successful',
    ['purchase_failed'] = 'Purchase failed',
}
