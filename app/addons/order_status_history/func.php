<?php
/***************************************************************************
 *                                                                          *
 *   (c) 2004 Vladimir V. Kalynyak, Alexey V. Vinokurov, Ilya M. Shalnev    *
 *                                                                          *
 * This  is  commercial  software,  only  users  who have purchased a valid *
 * license  and  accept  to the terms of the  License Agreement can install *
 * and use this program.                                                    *
 *                                                                          *
 ****************************************************************************
 * PLEASE READ THE FULL TEXT  OF THE SOFTWARE  LICENSE   AGREEMENT  IN  THE *
 * "copyright.txt" FILE PROVIDED WITH THIS DISTRIBUTION PACKAGE.            *
 ****************************************************************************/

use Tygh\Tygh;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

/**
 * Gets status history list by search params
 *
 * @param array  $params         Status search params
 * @param string $lang_code      2 letters language code
 * @param int    $items_per_page Items per page
 *
 * @return array Status list and Search params
 */
function fn_get_order_status_history($params = array(), $lang_code = CART_LANGUAGE, $items_per_page = 0)
{
    // Set default values to input params
    $default_params = array(
        'page' => 1,
        'items_per_page' => $items_per_page
    );



    $params = array_merge($default_params, $params);

    $sortings = array(
        'user_id' => '?:order_status_history.user_id',
        'order_id' => '?:order_status_history.order_id',
        'timestamp' => '?:order_status_history.timestamp',
        'new_status' => '?:order_status_history.new_status',
        'old_status' => '?:order_status_history.old_status',
    );

    $condition = $limit = $join = '';

    if (!empty($params['limit'])) {
        $limit = db_quote(' LIMIT 0, ?i', $params['limit']);
    }

    $sorting = db_sort($params, $sortings, 'timestamp', 'asc');

    if (!empty($params['item_ids'])) {
        $condition .= db_quote(' AND ?:order_status_history.order_id IN (?n)', explode(',', $params['item_ids']));
    }

    if (!empty($params['user_id'])) {
        $condition .= db_quote(' AND ?:order_status_history.user_id LIKE ?l', '%' . trim($params['user_id']) . '%');
    }

    if (!empty($params['old_status'])) {
        $condition .= db_quote(' AND ?:order_status_history.old_status = ?s', $params['old_status']);
    }

    if (!empty($params['new_status'])) {
        $condition .= db_quote(' AND ?:order_status_history.new_status = ?s', $params['new_status']);
    }

    if (!empty($params['period']) && $params['period'] != 'A') {
        list($params['time_from'], $params['time_to']) = fn_create_periods($params);
        $condition .= db_quote(' AND (?:order_status_history.timestamp >= ?i AND ?:order_status_history.timestamp <= ?i)', $params['time_from'], $params['time_to']);
    }

    $fields = array (
        'user_id' => '?:order_status_history.user_id',
        'order_id' => '?:order_status_history.order_id',
        'timestamp' => '?:order_status_history.timestamp',
        'new_status' => '?:order_status_history.new_status',
        'old_status' => '?:order_status_history.old_status',
    );

    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:order_status_history $join WHERE 1 $condition");
        $limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);
    }

    $status_history = db_get_array("SELECT * from ?:order_status_history". $sorting." ". $limit);

    $path = fn_get_files_dir_path();
    fn_mkdir($path);
    $file = fopen($path . 'debug_log.txt', 'a');

    if (!empty($file)) {
        fputs($file, 'TIME: ' . date('Y-m-d H:i:s', TIME) . "\n");
        fputs($file, fn_array2code_string($params) . "\n\n");
        fclose($file);
    }

    if (!empty($params['item_ids'])) {
        $status_history = fn_sort_by_ids($status_history, explode(',', $params['item_ids']), 'order_id');
    }

    return array($status_history, $params);
}

function fn_order_status_history_change_order_status($status_to, $status_from, $order_info, $force_notification, $order_statuses, $place_order) {

    db_query("INSERT INTO ?:order_status_history values (". $order_info['order_id'] . ",". Tygh::$app['session']['auth']['user_id'] . ", '".$status_to."' , '".$status_from."', " . time() .")");

}
