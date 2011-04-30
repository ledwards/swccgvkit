// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  assign_header_callbacks();
  assign_login_callbacks();
  assign_current_cardlist_callbacks();
  
  // replace buttons with loading spinner until response comes back
});

function assign_header_callbacks() {
  set_hint_text("#search_box", "Search for cards");
};

function assign_login_callbacks() {
  set_hint_text("#user_email", "Your email address");
  set_hint_text("#user_password", "password");
  set_hint_text("#user_password_confirmation", "notmatch");
};

function assign_current_cardlist_callbacks() {
  update_on_blur(".quantity");
  make_inline_editable(".cardlist_title", "#edit_title_link", "/cardlists/update_title");
};

function set_hint_text(selector, text) {
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

function update_on_blur(selector) {  
  $(selector).focus(function() {
    if ($(this).val() == $(this).attr("data-qty")) {
      $(this).val("");
    };
  });
  
  $(selector).blur(function() {
    if ($(this).val() == "") {
      $(this).val($(this).attr("data-qty"));
    }
    else {
      $.post("/cardlists/update_quantity.js", { "cardlist_item_id": $(this).attr("data-id"), "quantity": $(this).val() });
    };
  });
  
  // TODO: bind the post action to pressing enter as well
};

function make_inline_editable(target_selector, link_selector, post_url) {
  $(target_selector).editable(post_url, {
    event: "make_editable",
    submit: 'ok',
    callback: function(value, settings) {
      var id = $(this).attr("id");
      $("#saved_cardlist_" + id + " a").html(value);
    }
  });
  $(link_selector).click(function() {
    $(target_selector).trigger('make_editable');
    $(target_selector + " input").select();
    return false;
  });
};
