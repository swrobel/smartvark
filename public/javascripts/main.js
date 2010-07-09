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
	jQuery('.btn-signin-open').click(function (e) {
		jQuery('#signin-popup').modal();
		  return false;
	});
});
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
});
