 $(function () {
  function closeSearch() {
   var $form = $(".navbar-collapse form[role='search'].active");
   $form.find("input").val("");
   $form.removeClass("active");
 }
// Show Search if form is not active // event.preventDefault() is important, this prevents the form from submitting
$(document).on("click", ".navbar-collapse form[role='search']:not(.active) button[type='submit']", function(event) {
  event.preventDefault();
  var $form = $(this).closest("form");
  var $input = $form.find("input");
  console.log("simple-navbar click, not active");
  $form.addClass("active");
  $input.focus();
});

// https://goo.gl/5brf8y

// $('form').on('ajax:success', function(event, data, status, xhr) {
//   // Do your thing, data will be the response
//   console.log("Here I am 0");
//     var form = $(this).closest("form");
//     return true;
// });

// $('form#myForm').trigger('submit.rails');



$('form').submit(function() {  
    var valuesToSubmit = $(this).serialize();
    var action_url = $(this).attr('action');
    console.log("Submitting to " + action_url);
    console.log("valuesToSubmit: " + valuesToSubmit);
    $.ajax({
        type: "POST",
        url: $(this).attr('action'), //sumbits it to the given url of the form
        data: valuesToSubmit,
        dataType: "JSON" // you want a difference between normal and ajax-calls, and json is standard
    }).success(function(json){
        console.log("success", json);
    });
    return true; // prevents normal behaviour
});


// ONLY FOR DEMO // Please use $("form").submit(function(event)) to track from submission
// if your form is ajax remember to call `closeSearch()` to close the search container
// $(document).on("click", ".navbar-collapse form[role='search'].active button[type='submit']", function(event) {
// $("form").submit(function(event) {
//   // event.preventDefault();
//   var $form = $(this).closest("form");
//   var $input = $form.find("input");
//   console.log("simple-navbar click, active, input is " + $input.val() + ", form is " + $form);
//   // $("form").submit(function(event){
//   //   console.log("form.submit(function(event))");
//   //   $form.trigger("submit.rails");

//   // });
//   // $("#showSearchTerm").text($input.val());
//   closeSearch();
// });
});
 