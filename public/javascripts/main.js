$(document).ready(function(){
	$('ul.accordion').accordion({
		active: ".selected",
		autoHeight: false,
		header: ".opener",
		collapsible: true,
		event: "click"
	});

	$('ul.accordion2').accordion({
		autoHeight: false,
		header: ".opener",
		collapsible: true,
		fillSpace: true,
		event: "click"
	});

});
$(function ($) {
	$('.btn-signin-open').click(function (e) {
		$('.popup').modal();
		  return false;
	});
});
$(function() {
	//abort if browser supports HTML5 placeholder attribute
	if ('placeholder' in document.createElement('input')) return;
	$("#search_terms").placeHeld();
	$("#location").placeHeld();
});
