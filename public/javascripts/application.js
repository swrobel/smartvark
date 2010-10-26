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
	//abort if browser supports HTML5 placeholder attribute
	if ('placeholder' in document.createElement('input')) return;
	jQuery("#search_terms").placeHeld();
	jQuery("#location").placeHeld();
	jQuery("#offer_lead").placeHeld();
	jQuery("#offer_description").placeHeld();
	jQuery("#offer_exclusivity_text").placeHeld();
	jQuery("#offer_redemption_code").placeHeld();
});
function checkall_offer_form(n) {
	jQuery("input[name='offer[business_ids][]']").attr('checked',n);
}

function checkall(n) {
	jQuery("input[name='business_ids[]']").attr('checked',n);
	jQuery("#biz_"+n).attr('class', 'active')
	jQuery("#biz_"+!n).attr('class', '')
}
