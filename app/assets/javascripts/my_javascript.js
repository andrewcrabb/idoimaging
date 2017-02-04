function showSearchText() {
  $("#show_search_text").click(function(){
    showSearchForm(true);
    $(".search_params").hide();
  });
};

function showingResults () {
  url = window.location.href;
  regex = new RegExp("[?&]q%5B.+%5D");
  match = regex.exec(url);
  showing = (match) ? true : false;
  console.log("showingResults returning: " + showing);
  return showing;
};

function showSearchForm(showForm) {
  console.log("--- Page load ---")
  console.log("showSearchForm: " + showForm);
  if (showForm) {
    console.log("show form, hide text");
    $("#search_form").show();
    $("#show_search_text").hide();
  } else {
    console.log("hide form, show text");
    $("#search_form").hide();
    $("#show_search_text").show();
  }
};

function doTabs() {
  console.log("doTabs")
  showSearchForm(!showingResults());
  if ($("#tabs").length) {
    console.log("yes I have tabs");
    $( "#tabs" ).tabs();
  } else {
    console.log("no I do not have tabs");
  }

  $("#show_search_text").click(function(){
    showSearchForm(true);
    $(".search_params").hide();
  });

};

// function ready() {
// var ready;
// ready = function() {
// http://stackoverflow.com/questions/18770517/rails-4-how-to-use-document-ready-with-turbo-links
$(document).on('turbolinks:load', function() {
  console.log("-------- ready() -----------")
  doStarRating();
  // doTabs();
  showSearchText();
  showSearchForm(!showingResults());
});

// $(document).on('turbolinks:load', ready);
