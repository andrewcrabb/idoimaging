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
// ONLY FOR DEMO // Please use $("form").submit(function(event)) to track from submission
// if your form is ajax remember to call `closeSearch()` to close the search container
// $(document).on("click", ".navbar-collapse form[role='search'].active button[type='submit']", function(event) {
$("form").submit(function(event) {
  event.preventDefault();
  var $form = $(this).closest("form");
  var $input = $form.find("input");
  console.log("simple-navbar click, active, input is " + $input.val() + ", form is " + $form);
  // $("form").submit(function(event){
  //   console.log("form.submit(function(event))");
  //   $form.trigger("submit.rails");

  // });
  // $("#showSearchTerm").text($input.val());
  closeSearch();
});
});
 