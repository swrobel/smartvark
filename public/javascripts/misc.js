function remote_function(select, link) {
 $.post(link + "/" + retrieve_option_value(select), "", null, "script");
}

function retrieve_option_value(select) {
  $(select).children(":selected").val();
}
