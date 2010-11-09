jQuery.noConflict();
jQuery(document).ready(function(){
	jQuery('ul.accordion').accordion({
		active: ".selected",
		autoHeight: false,
		header: ".opener",
		collapsible: true,
		event: "click"
	});

	jQuery('ul.accordion2').accordion({
		autoHeight: false,
		header: ".opener",
		collapsible: true,
		fillSpace: true,
		event: "click"
	});

});
jQuery(function (jQuery) {
	jQuery('#btn-signin-open').click(function (e) {
		jQuery('#signin-popup').modal();
		  return false;
	});
});
jQuery(function (jQuery) {
	jQuery('#btn-signup-open').click(function (e) {
		jQuery('#signup-popup').modal();
		  return false;
	});
});
/********HACK  BEGIN****/
//If user not logged in, and hits redeem show signin
jQuery(function (jQuery) {
	jQuery('#btn-redeem-signup-open').click(function (e) {
		jQuery('#signup-popup').modal();
		  return false;
	});
});
/********HACK  END****/
jQuery(function (jQuery) {
	jQuery('#btn-redeem-open').click(function (e) {
		jQuery('#redeem-popup').modal();
		  return false;
	});
});
jQuery(function() {
	jQuery("#offer_offer_active_on").datepicker();
	jQuery("#offer_expiry_datetime").datepicker();
});
jQuery(function() {
	//abort if browser supports HTML5 placeholder attribute
	if ('placeholder' in document.createElement('input')) return;
	jQuery("#search_terms").placeHeld();
	jQuery("#location").placeHeld();
	jQuery("#offer_lead").placeHeld();
	jQuery("#offer_description").placeHeld();
	jQuery("#offer_exclusivity_text").placeHeld();
});
jQuery(function (jQuery) {
    jQuery(".dashboard_chk").change(function(){
        isChecked = jQuery(this).attr("checked");
        locName = jQuery(this).parent().text().trim();
        jQuery(".location").find("td").each(function(){
            if(jQuery(this).text() == locName) if(isChecked) jQuery(this).parent().show(); else jQuery(this).parent().hide();
        });
    });
});
function checkall_offer_form(n) {
	jQuery(".location_chk").attr('checked',n);
}
function checkall(n) {
	jQuery(".chk").attr('checked',n);
	if (n) jQuery(".dashboard_row").show();
	else jQuery(".dashboard_row").hide();
}
