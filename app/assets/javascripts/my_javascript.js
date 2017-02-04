
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
  // doTabs();
  showSearchText();
  showSearchForm(!showingResults());
});

// $(document).on('turbolinks:load', ready);
