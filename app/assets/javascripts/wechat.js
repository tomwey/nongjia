//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require jquery.mobile.custom.min
//= require_self

window.App = {
  alert: function(msg, to) {
    $(to).before("<div class='alert alert-danger' id='alert-comp'><a class='close' href='#' data-dismiss='alert'>×</a>" + msg + "</div>");
  },
  openUrl: function(url) {
    if (url.length == 0 ) {
      return false;
    }
    
    window.location.href = url;
    return false;
  },
  payment2: function(orderNo) {
    $.ajax({
      url: '/wx-shop/orders/payment',
      type: 'POST',
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      },
      data: {
        order_no: orderNo
      }
    })
  },
  payment: function(event, ele) {
    
    if (event.stopPropagation) {
      event.stopPropagation();
    } else {
      event.cancelBubble = true;
    }
    
    var $ele = $(ele);
    
    if ($ele.data('loading') === '1') {
      return false;
    }
    
    $ele.data('loading', '1');
    
    $ele.text('支付中');
    
    var orderNo = $ele.data('order-no');
    
    if (orderNo === '') {
      $('.new-order form').submit();
      return false;
    } 
    
    $.ajax({
      url: '/wx-shop/orders/payment',
      type: 'POST',
      data: {
        order_no: orderNo,
        is_order_detail: $ele.data('order-detail')
      }
    })
    
  }
};

$(document).ready(function() {
  $(".carousel-inner").swiperight(function() {
    $(this).parent().carousel('prev');
  });
  $(".carousel-inner").swipeleft(function() {
    $(this).parent().carousel('next');
  });
});


