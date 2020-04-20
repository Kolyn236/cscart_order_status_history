{capture name="mainbox"}

    <form action="{""|fn_url}" method="post" name="order_history_form" class=" cm-hide-inputs" enctype="multipart/form-data">
        <input type="hidden" name="fake" value="1" />
        {include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id="pagination_order_history"}

        {assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}

        {assign var="rev" value=$smarty.request.content_id|default:"pagination_order_history"}
        {assign var="c_icon" value="<i class=\"icon-`$search.sort_order_rev`\"></i>"}
        {assign var="c_dummy" value="<i class=\"icon-dummy\"></i>"}

        {if $order_history}
            <div class="table-responsive-wrapper">
                <table class="table table-middle table--relative table-responsive">
                    <thead>
                    <tr>
                        <th width="1%" class="left mobile-hide">
                            {include file="common/check_items.tpl" class="cm-no-hide-input"}</th>
                        <th><a class="cm-ajax" href="{"`$c_url`&sort_by=order_id&sort_order=`$params.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("order_id")}{if $search.sort_by == "order_id"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th class="mobile-hide"><a class="cm-ajax" href="{"`$c_url`&sort_by=user_id&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("user_id")}{if $search.sort_by == "user_id"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th class="mobile-hide"><a class="cm-ajax" href="{"`$c_url`&sort_by=old_status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("old_status_history")}{if $search.sort_by == "old_status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th class="mobile-hide"><a class="cm-ajax" href="{"`$c_url`&sort_by=new_status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("new_status_history")}{if $search.sort_by == "new_status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th class="mobile-hide"><a class="cm-ajax" href="{"`$c_url`&sort_by=timestamp&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("date")}{if $search.sort_by == "timestamp"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>

                        {hook name="order_status_history:manage_header"}
                        {/hook}
                    </tr>
                    </thead>
                    {foreach from=$order_history item=item}
                        <tr class="cm-row-status-{$item.order_id}">
                            {assign var="allow_save" value=$item|fn_allow_save_object:"status_history"}

                            {if $allow_save}
                                {assign var="no_hide_input" value="cm-no-hide-input"}
                            {else}
                                {assign var="no_hide_input" value=""}
                            {/if}

                            <td class="left mobile-hide">
                                <input type="checkbox" name="order_ids[]" value="{$item.order_id}" class="cm-item {$no_hide_input}" /></td>
                            <td class="{$no_hide_input}" data-th="{__("order_id")}">
                                <a class="row-status" href="{"order_status_history.update?order_id=`$item.order_id`"|fn_url}">{$item.order_id}</a>
                            </td>

                            <td class="{$no_hide_input}" data-th="{__("user_id")}">
                                <a class="row-status" href="{"order_status_history.update?order_id=`$item.user_id`"|fn_url}">{$item.user_id}</a>
                            </td>

                            <td class="{$no_hide_input}" data-th="{__("old_status")}">
                                <a class="row-status" href="{"order_status_history.update?order_id=`$item.user_id`"|fn_url}">{$item.old_status}</a>
                            </td>

                            <td class="{$no_hide_input}" data-th="{__("new_status")}">
                                <a class="row-status" href="{"order_status_history.update?order_id=`$item.user_id`"|fn_url}">{$item.new_status}</a>
                            </td>

                            <td class="{$no_hide_input}" data-th="{__("user_id")}">
                                <a class="row-status" href="{"order_status_history.update?order_id=`$item.user_id`"|fn_url}">{$item.timestamp}</a>
                            </td>

                            {hook name="banners:manage_data"}
                            {/hook}

                            <td class="mobile-hide">
                                {capture name="tools_list"}
                                    <li>{btn type="list" text=__("edit") href="banners.update?banner_id=`$banner.banner_id`"}</li>
                                    {if $allow_save}
                                        <li>{btn type="list" class="cm-confirm" text=__("delete") href="banners.delete?banner_id=`$banner.banner_id`" method="POST"}</li>
                                    {/if}
                                {/capture}
                                <div class="hidden-tools">
                                    {dropdown content=$smarty.capture.tools_list}
                                </div>
                            </td>
                        </tr>
                    {/foreach}
                </table>
            </div>
        {else}
            <p class="no-items">{__("no_data")}</p>
        {/if}

        {include file="common/pagination.tpl" div_id="pagination_contents_banners"}

        {capture name="buttons"}
            {capture name="tools_list"}
                {if $banners}
                    <li>{btn type="delete_selected" dispatch="dispatch[banners.m_delete]" form="banners_form"}</li>
                {/if}
            {/capture}
            {dropdown content=$smarty.capture.tools_list class="mobile-hide"}
        {/capture}
        {capture name="adv_buttons"}
            {hook name="order_status_history:adv_buttons"}
                {include file="common/tools.tpl" tool_href="banners.add" prefix="top" hide_tools="true" title=__("add_banner") icon="icon-plus"}
            {/hook}
        {/capture}

    </form>

{/capture}

{capture name="sidebar"}
    {hook name="order_status_history:manage_sidebar"}
        {include file="common/saved_search.tpl" dispatch="order_status_history.manage" view_type="banners"}

    {/hook}
{/capture}

{include file="common/mainbox.tpl" title=$page_title content=$smarty.capture.mainbox buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.adv_buttons select_languages=$select_languages sidebar=$smarty.capture.sidebar}

{** ad section **}