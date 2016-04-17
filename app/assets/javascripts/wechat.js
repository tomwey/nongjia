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

  payment: function(event, ele) {
    
    if (event.stopPropagation) {
      event.stopPropagation();
    } else {
      event.cancelBubble = true;
    }
    
    var $ele = $(ele);
    var orderNo = $ele.data('order-no');
    
    $.ajax({
      url: '/wx-shop/orders/payment',
      type: 'POST',
      data: {
        order_no: orderNo
      }
    })
    
  }
};


