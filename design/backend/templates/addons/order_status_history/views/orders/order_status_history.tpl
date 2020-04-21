{capture name="mainbox"}

    <form action="{""|fn_url}" method="post" name="order_history_form" class=" cm-hide-inputs" enctype="multipart/form-data">
        <input type="hidden" name="fake" value="1" />
        {include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id="pagination_order_status_history"}

        {assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}

        {assign var="rev" value=$smarty.request.content_id|default:"pagination_order_status_history"}
        {assign var="c_icon" value="<i class=\"icon-`$search.sort_order_rev`\"></i>"}
        {assign var="c_dummy" value="<i class=\"icon-dummy\"></i>"}

        {if $order_history}
            <div class="table-responsive-wrapper">
                <table class="table table-middle table--relative table-responsive">
                    <thead>
                    <tr>
                        <th class="mobile-hide"><a class="cm-ajax" href="{"`$c_url`&sort_by=order_id&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("order_id")}{if $search.sort_by == "order_id"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th class="mobile-hide"><a class="cm-ajax" href="{"`$c_url`&sort_by=user_id&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("user_id")}{if $search.sort_by == "user_id"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th class="mobile-hide"><a class="cm-ajax" href="{"`$c_url`&sort_by=old_status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("old_status_history")}{if $search.sort_by == "old_status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th class="mobile-hide"><a class="cm-ajax" href="{"`$c_url`&sort_by=new_status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("new_status_history")}{if $search.sort_by == "new_status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                        <th class="mobile-hide"><a class="cm-ajax" href="{"`$c_url`&sort_by=timestamp&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("date")}{if $search.sort_by == "timestamp"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>

                    </tr>
                    </thead>
                    {foreach from=$order_history item=item}
                        <tr class="cm-row-status-{$item.order_id}">

                            <td class="{$no_hide_input}" data-th="{__("order_id")}">
                                <span class="row-status">{$item.order_id}</span>
                            </td>

                            <td class="{$no_hide_input}" data-th="{__("user_id")}">
                                <span class="row-status">{$item.firstname}</span>
                            </td>

                            <td>
                                <span href="#" class="btn o-status-{$item.old_status|lower}">{$item.old_status_text}</span>
                            </td>

                            <td>
                                <span href="#" class="btn o-status-{$item.new_status|lower}">{$item.new_status_text}</span>
                            </td>

                            <td class="{$no_hide_input}" data-th="{__("user_id")}">
                                <span class="row-status">{$item.timestamp|date_format:"`$settings.Appearance.date_format`"}</span>
                            </td>

                        </tr>
                    {/foreach}
                </table>
            </div>
        {else}
            <p class="no-items">{__("no_data")}</p>
        {/if}

        {include file="common/pagination.tpl" div_id="pagination_order_status_history"}

    </form>

{/capture}

{include file="common/mainbox.tpl" title=$page_title content=$smarty.capture.mainbox buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.adv_buttons select_languages=$select_languages sidebar=$smarty.capture.sidebar}

{** ad section **}
