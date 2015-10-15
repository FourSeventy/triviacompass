//$.ajax({
//    url: 'http://localhost:3000/ratings',
//    method: 'POST',
//    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
//    data: {rating: 5, bar_id: 3},
//    success: function(data){
//        console.log(data);
//    }
//});