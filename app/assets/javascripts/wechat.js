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
  showProductDetail: function(ele) {
    var $ele = $(ele);
    var id = $ele.data("id");
    var sale_id = $ele.data("sale-id");
    if (sale_id === undefined) {
      sale_id = "";
    } else {
      sale_id = "?sid=" + sale_id
    }
    window.location.href = "/wx-shop/products/" + id + sale_id;
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
  
//   var time = $(".countdown").data("duration").to_i;
//   
//   var timer = setInterval(function() {
//   if (time < 0) {
//     clearInterval(timer);
//     return;
//   }
// 
//   var hour = time / 3600;
//   var min  = ( time - 3600 * 24 ) / 60;
//   var sec  = time - 3600 * 24 - min * 60;
// 
//   $(".countdown .hour").text(hour);
//   $(".countdown .min").text(min);
//   $(".countdown .sec").text(sec);
// }, 1000);
var time = parseInt($(".flash-sales .countdown").data("duration"));
var timer = setInterval(function() {
  // console.log(time);
  if (time < 0) {
    clearInterval(timer);
    return;
  }

  var hour = Math.floor(time / 3600);
  var min  = Math.floor(( time - 3600 * hour ) / 60);
  var sec  = time - 3600 * hour - min * 60;

  $(".countdown .hour").text(pad(hour,2));
  $(".countdown .min").text(pad(min,2));
  $(".countdown .sec").text(pad(sec,2));
  
  time --;
}, 1000);

function pad(num, n) {  
    var len = num.toString().length;  
    while(len < n) {  
        num = "0" + num;  
        len++;  
    }  
    return num;  
} 
});



