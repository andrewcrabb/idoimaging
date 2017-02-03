// Copied form program_rating.js
// Code from http://bit.ly/2fH7SDJ
// Inspiration from http://bit.ly/2afBjgp


function doStarRating() {
  program_data   = document.getElementById('program_data')
  if (!program_data) {
    console.log("doStarRating exiting");
    return;
  }
    console.log("doStarRating proceeding");

  dataset        = program_data.dataset
  user           = dataset.userid
  program        = dataset.programid;
  old_rating     = dataset.rating;

  $("#my-rating").starRating({
    initialRating: old_rating,
    starSize: 20,
    callback: function(currentRating, $el){
      $('#my-rating').starRating('setReadOnly', false);
      console.log("callback: program " + program + ", user " + user + ", rating " + currentRating);
      $.ajax({
        type: "PUT",
        url: "/programs/" + program +  "/rating",
        data: { rating: currentRating, user: user }
      });

    }
  });
};

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
