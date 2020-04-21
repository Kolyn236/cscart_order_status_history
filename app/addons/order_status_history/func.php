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

    $fields = array (
        '?:order_status_history.user_id',
        '?:order_status_history.order_id',
        '?:order_status_history.timestamp',
        '?:order_status_history.new_status',
        '?:order_status_history.old_status',
        '?:users.firstname'
    );

    $sorting = db_sort($params, $sortings, 'timestamp', 'asc');


    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:order_status_history");
        $limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);
    }

    $join = 'left join ?:users on ?:order_status_history.user_id = ?:users.user_id';

    $status_history_list = db_get_array(
        "SELECT ?p FROM ?:order_status_history " .
        $join .
        " WHERE 1 ?p ?p",
        implode(', ', $fields), $sorting, $limit
    );

    $order_statuses = fn_get_statuses(STATUSES_ORDER, [], true, true);

    foreach ($status_history_list as &$history){
        $history['new_status_text'] = $order_statuses[$history['new_status']]['description'];
        $history['old_status_text'] = $order_statuses[$history['old_status']]['description'];
    }

    return array($status_history_list, $params, $order_statuses);
}

/**
 * Save old and new status of history order
 *
 * @param $status_to
 * @param $status_from
 * @param $order_info
 * @param $force_notification
 * @param $order_statuses
 * @param $place_order
 * @return bool
 */
function fn_order_status_history_change_order_status($status_to, $status_from, $order_info, $force_notification, $order_statuses, $place_order) {

    db_query("INSERT INTO ?:order_status_history values (". $order_info['order_id'] . ",". Tygh::$app['session']['auth']['user_id'] . ", '".$status_to."' , '".$status_from."', " . time() .")");

    return true;
}
