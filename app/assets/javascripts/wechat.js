//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require jquery.touchSwipe.min
//= require_self

window.App = {
  alert: function(msg, to) {
    $(to).before("<div class='alert alert-danger' id='alert-comp'><a class='close' href='#' data-dismiss='alert'>×</a>" + msg + "</div>");
  },
};


