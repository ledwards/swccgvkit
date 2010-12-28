// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
	set_hint_text("#search_box", "Search for cards");
	set_hint_text("#user_email", "Your email address");
	set_hint_text("#user_password", "password");
});

function set_hint_text(selector, text){
	$(selector).focus(function() {
		$(this).val("");
	});

	$(selector).blur(function() {
		if ($(this).val() == "") {
			$(this).val(text);
		};
	});
};