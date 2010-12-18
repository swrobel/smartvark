$(function(){
	$("#parent_category").change(function() {
		$(".child_select").hide();
		$("#children_of_"+$(this).val()).show();
	});
	
	$(".child_select").change(function() {
		$("#offer_category_id").val($(this).val());
		$("#user_category_id").val($(this).val());
	});
	
	if ($().accordion) {
		$('.accordion').accordion({
			active: ".selected",
			autoHeight: false,
			header: ".opener",
			collapsible: true,
			event: "click"
		});
	}
	
	if ($().modal) {
		$.extend($.modal.defaults, {
		    onOpen: function (dialog) {
			dialog.overlay.fadeIn('fast');
			dialog.container.fadeIn('fast');
			dialog.data.fadeIn('fast');
			},
			onClose: function (dialog) {
			dialog.data.fadeOut('fast');
			    dialog.container.fadeOut('fast');
				dialog.overlay.fadeOut('fast', function () {$.modal.close();});
			}
		});
	
		$('#btn-signin-open').click(function (e) {
			$('#signin-popup').modal();
			  return false;
		});
	    
		$('#btn-signup-open').click(function (e) {
			$('#signup-popup').modal();
			  return false;
		});
		
		$('#btn-redeem-signup-open').click(function (e) {
			$('#signup-popup').modal();
			  return false;
		});
		
		$('#btn-redeem-open').click(function (e) {
			$('#redeem-popup').modal();
			  return false;
		});
		
		$('#signin-from-signup').click(function () {
			$.modal.close();
			window.setTimeout(function() {$('#signin-popup').modal()}, 500);
			  return false;
		});
		
		$('#signup-from-signin').click(function () {
			$.modal.close();
			window.setTimeout(function() {$('#signup-popup').modal()}, 500);
			  return false;
		});
	}
	
	if ($().jMapping)
		$('#map').jMapping();
	
	if ($().datepicker) {
		$("#offer_start_date").datepicker();
		$("#offer_end_date").datepicker();
	}
	
	if ($().placehold) {
		$("#search_terms").placehold();
		$("#location").placehold();
		$("#offer_title").placehold();
		$("#offer_description").placehold();
		$("#offer_fine_print").placehold();
		$("#offer_redemption_code").placehold();
	}
	
	if ($().textareaCount) {
		$("#offer_title").textareaCount({maxCharacterSize: 50}, function(data) {$("#offer_title_count").html(data.left+" characters remaining");});
		$("#offer_description").textareaCount({maxCharacterSize: 200}, function(data) {$("#offer_description_count").html(data.left+" characters remaining");});
		$("#offer_fine_print").textareaCount({maxCharacterSize: 200}, function(data) {$("#offer_fine_print_count").html(data.left+" characters remaining");});
	}
	
	if ($().fadeIn && $.fadeOut) {
		$(".dashboard_chk").change(function(){
			locID = '.' + $(this).val();
			if ($(this).attr("checked")) $(locID).fadeIn('fast');
			else $(locID).fadeOut('fast');
		});
	}
    
	if ($(".flash-holder").html() != "") {
	    $(".flash-holder").show("drop", { direction: "up" }, 1000).delay(5000).hide("drop", { direction: "up" }, 1000);
	}
});
function checkall_offer_form(n) {
	$(".location_chk").attr('checked',n);
}
function checkall(n) {
	$(".chk").attr('checked',n);
	if (n) $(".dashboard_row").fadeIn('fast');
	else $(".dashboard_row").fadeOut('fast');
}
