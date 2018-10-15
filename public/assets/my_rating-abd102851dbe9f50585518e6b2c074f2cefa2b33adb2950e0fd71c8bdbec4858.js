// Copied form program_rating.js
// Code from http://bit.ly/2fH7SDJ
// Inspiration from http://bit.ly/2afBjgp


function doStarRating() {
  program_data   = document.getElementById('program_data')
  if (!program_data) {
    return;
  }

  dataset        = program_data.dataset
  user           = dataset.userid
  program        = dataset.programid;
  old_rating     = dataset.rating;
  console.log("doStarRating: user = " + user + ", old_rating = " + old_rating);

  $("#my-rating").starRating({
    initialRating: old_rating,
    starSize: 20,
    callback: function(currentRating, $el){
      $('#my-rating').starRating('setReadOnly', false);
      // console.log("callback: program " + program + ", user " + user + ", rating " + currentRating);
      $.ajax({
        type: "PUT",
        url: "/programs/" + program +  "/rating",
        data: { rating: currentRating, user: user }
      });

    }
  });
};

$(document).on('turbolinks:load', function() {
  // console.log("-------- my_rating::ready() -----------")
  doStarRating();
});
