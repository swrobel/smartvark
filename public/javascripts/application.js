$(function(){
	$('.accordion').accordion({
		active: ".selected",
		autoHeight: false,
		header: ".opener",
		collapsible: true,
		event: "click"
	});
	
	$.extend($.modal.defaults, {
	    onOpen: function (dialog) {
	        dialog.overlay.fadeIn('fast');
	        dialog.container.fadeIn('fast');
	        dialog.data.fadeIn('fast');
		}, onClose: function (dialog) {
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
	
	$("#offer_offer_active_on").datepicker();
	$("#offer_expiry_datetime").datepicker();
	
	$("#search_terms").placehold();
	$("#location").placehold();
	$("#offer_lead").placehold();
	$("#offer_description").placehold();
	$("#offer_exclusivity_text").placehold();
	
	$(".dashboard_chk").change(function(){
        isChecked = $(this).attr("checked");
        locName = $(this).parent().text().trim();
        $(".location").find("td").each(function(){
            if($(this).text() == locName) if(isChecked) $(this).parent().fadeIn('fast'); else $(this).parent().fadeOut('fast');
        });
    });
    
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
