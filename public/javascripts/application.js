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
		
		$('#show-terms').click(function (e) {
			$('#terms-popup').modal();
			  return false;
		});
		
		$('#show-privacy').click(function (e) {
			$('#privacy-popup').modal();
			  return false;
		});
	}
	
	if ($().jMapping) {
		$('#map').jMapping({
			default_point: {
				lat: 34.0522342,
				lng: -118.2436849
			}
		});
  }
	
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
		$("#user_email").placehold();
		$("#user_password").placehold();
		$("#user_password_confirmation").placehold();
		$("#shoutbox").placehold();
	}
	
	if ($().textareaCount) {
		function createCount(field, max) {
			var count_text = " characters remaining";
			var count_field = field + "_count";
			$(count_field).html(max + count_text);
			$(field).textareaCount({maxCharacterSize: max}, function(data) {
				if ($(field).val().substr(0, 8) != "Example:") {
					$(count_field).html(data.left + count_text);
				}
			});
		}
		
		createCount("#offer_title", 40);
		createCount("#offer_description", 200);
		createCount("#offer_fine_print", 200);
	}
	
	if ($().fadeIn && $().fadeOut) {
		$(".dashboard_chk").change(function(){
			bizID = $(this).val();
			$("#unchecked-bizs").toggleClass(bizID);
			if ($(this).attr("checked")) $("."+bizID).fadeIn("fast");
			else {
				bizIDs = $("#unchecked-bizs").attr("class");
				alert(bizIDs);
				$("tr[class='"+bizIDs+"  dashboard_row']").fadeOut("fast");
				$("tr[class='"+bizIDs+" draft dashboard_row']").fadeOut("fast");
				$("tr[class='"+bizIDs+" archived dashboard_row']").fadeOut("fast");
			}
		});
	}
    
	if ($(".flash-holder").html() != "") {
	    $(".flash-holder").show("drop", { direction: "up" }, 1000).delay(10000).hide("drop", { direction: "up" }, 1000);
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
