{*
* 2007-2015 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2015 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

{extends file="helpers/form/form.tpl"}

{block name="script"}
$(document).ready(function(){

/* move ne sert plus grace au drag & drop
	$('#menuOrderUp').click(function(e){
	e.preventDefault();
    move(true);
});
$('#menuOrderDown').click(function(e){
    e.preventDefault();
    move();
}); */

$("#items").closest('form').on('submit', function(e) {
	$("#items option").prop('selected', true);
});
$("#addItem").click(add);
$("#availableItems").dblclick(add);
$("#removeItem").click(remove);
$("#items").dblclick(remove);
var checkbox = '<input type="checkbox" class="del" value="">&nbsp;'
$("#items li").prepend(checkbox);


/* permet d'avoir un glisser deposer pour les éléments du menu */
$("#items").sortable({
	placeholder: "btn btn-default active btn-block",
	update: function(event, ui){
		var list= ui.item.parent('ul');
		var pos= 0;
		list.find("li").each(function(){
			pos++;
			$(this).find("input").attr("name", "items["+pos+"][name]");
		});
	}
});
function add()
{
	$("#availableItems option:selected").each(function(i){
		var val = $(this).val();
		var text = $(this).text();
		text = text.replace(/(^\s*)|(\s*$)/gi,"");
		if (val == "PRODUCT")
		{
			val = prompt('{l s="Indicate the ID number for the product" mod='blocktopmenu' js=1}');
			if (val == null || val == "" || isNaN(val))
				return;
			text = '{l s="Product ID #" mod='blocktopmenu' js=1}'+val;
			val = "PRD"+val;
		}
		{*$("#items").append('<option value="'+val+'" selected="selected">'+text+'</option>');*}
		index = ($("#items").children().length)+1
		$("#items").append('<li class="btn btn-default btn-block">'+checkbox+'&nbsp;'+text+'<input type="hidden" name="items['+index+'][name]" value="'+val+'"></li>');
	});
	serialize();
	return false;
}

	// Changement de la fonction remove pour fonctionner avec un liste
function remove()
{
	$("#items li input:checked").parents("li").remove();
	var pos=0;
	$("#items li").each(function(){
		pos++;
		$(this).find("input").attr("name", "items["+pos+"][name]")
	})
	return false;
}
function serialize()
{
	var options = "";
	$("#items option").each(function(i){
		options += $(this).val()+",";
	});
	$("#itemsInput").val(options.substr(0, options.length - 1));
}


	// Plus besoin de la fonction move avec le systeme de glisser deposer
/* function move(up)
{
        var tomove = $('#items option:selected');
        if (tomove.length >1)
        {
                alert('{l s="Please select just one item" mod='blocktopmenu'}');
                return false;
        }
        if (up)
                tomove.prev().insertAfter(tomove);
        else
                tomove.next().insertBefore(tomove);
        serialize();
        return false;
}
	*/

});
{/block}

{block name="input"}
    {if $input.type == 'link_choice'}
	    <div class="row">
	    	<div class="col-lg-4">
	    		<h4 style="margin-top:5px;">{l s='Available items' mod='blocktopmenu'}</h4>
	    		{$choices}
				<div class="col-lg-4"><a href="#" id="addItem" class="btn btn-default"><i class="icon-arrow-right"></i> {l s='Add' mod='blocktopmenu'}</a></div>
	    	</div>
			{*<div class="row">
				<div class="col-lg-1"></div>
				<div class="col-lg-4"><a href="#" id="removeItem" class="btn btn-default"><i class="icon-arrow-left"></i> {l s='Remove' mod='blocktopmenu'}</a></div>
				<div class="col-lg-4"><a href="#" id="addItem" class="btn btn-default"><i class="icon-arrow-right"></i> {l s='Add' mod='blocktopmenu'}</a></div>
			</div>*}
	    	<div class="col-lg-4 col-lg-offset-2">
	    		<h4 style="margin-top:5px;">{l s='Selected items' mod='blocktopmenu'}</h4>
	    		{$selected_links}
				<div class="col-lg-4"><a href="#" id="removeItem" class="btn btn-default"><i class="icon-arrow-left"></i> {l s='Remove' mod='blocktopmenu'}</a></div>
			</div>
	    	{* Plus nécessaire avec le drag and drop
	    	<div class="col-lg-1 col-lg-offset-1">
	    		<h4 style="margin-top:5px;">{l s='Change position' mod='blocktopmenu'}</h4>
                <a href="#" id="menuOrderUp" class="btn btn-default" style="font-size:20px;display:block;"><i class="icon-chevron-up"></i></a><br/>
                <a href="#" id="menuOrderDown" class="btn btn-default" style="font-size:20px;display:block;"><i class="icon-chevron-down"></i></a><br/>
	    	</div>*}

	    </div>
	    <br/>
	{else}
		{$smarty.block.parent}
    {/if}
{/block}
