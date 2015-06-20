$(document).ready(function() {
  bindEvents();
 }); //ready

function bindEvents() {
  $('.brewery_search').submit(function(event) {
    event.preventDefault();
    $.ajax({
      url: '/breweries',
      type: 'GET',
      data: {q: $(".brewery_search .brewery").val()}
      })
    .done(function(data) {
      var response_json = JSON.parse(data);
      var parsed_data = JSON.parse(response_json.data)
      $(".main").css("height", "200px") //resize mainpage
      $('.brewery_name').html(
      parsed_data.data[0].name)
        for(var i=1;i<parsed_data.data.length; i++) {
          $('.beer_result').append('<h2>' +parsed_data.data[i].name + '</h2>' + '<h3>Description</h3>' + parsed_data.data[i].description )
        } //for loop
      }) //done
  }); //submit

  $('.main .register').on('click', function(event){
      event.preventDefault();
     $( "#registrationPane" ).css( "visibility", "visible")
   });

  $("#registrationForm").submit(function(event) {
    event.preventDefault();
    $.ajax({
      url: '/register',
      type: 'POST',
      data: $('#registrationForm').serialize()
      }).done(function(response) {
        var new_user = JSON.parse(response);
        $('.auth_div').hide()
        $('#registrationPane').css("visibility", "hidden")
        $('.new_auth').html("<h2>Welcome " +new_user.user_name + "</h2>");
        $('.log_out').css("visibility", "visible");
      }) //done
  }); //submit

 $('.main .log_in').on('click', function(event){
    event.preventDefault();
    $( "#loginPane" ).css( "visibility", "visible")
   });

  $("#loginForm").submit(function(event) {
    event.preventDefault();
    $.ajax({
      url: '/login',
      type: 'POST',
      data: $('#loginForm').serialize()
      }).done(function(response) {
        var new_user = JSON.parse(response);
        $('.auth_div').hide()
        $('#loginPane').css("visibility", "hidden")
        $('.new_auth').html("<h2>Welcome " +new_user.user_name + "</h2>");
        $('.log_out').css("visibility", "visible");
      }).fail(function(response) {
        console.log("We don't know who you are");
      }); //done
  }); //submit

  $(".log_out").click(function(event){
    event.preventDefault();
      $.ajax({
        url: '/logout',
        type: 'GET'
      })
      // .done({
      //   $('.auth_div').show();
      // })
    })
      // .done(function(response) {
  //       var new_user = JSON.parse(response);
  //       response.user_id = nil;
  //     })
  // }) //log_out
}; // bindevents