// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
	set_hint_text("#search_box", "Search for cards");
	set_hint_text("#user_email", "Your email address");
	set_hint_text("#user_password", "password");
	set_hint_text("#user_password_confirmation", "notmatch");
	
	// Set hint text-like behavior on card qty, replace buttons with loading spinner until response comes back
});

function set_hint_text(selector, text){
	$(selector).val(text);
	
	$(selector).focus(function() {
		if ($(this).val() == text) {
			$(this).val("");
		};
	});

	$(selector).blur(function() {
		if ($(this).val() == "") {
			$(this).val(text);
		};
	});
};
