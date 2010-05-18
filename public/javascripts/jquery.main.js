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