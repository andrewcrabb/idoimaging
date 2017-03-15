// $(".slick-slider").not('.slick-initialized').slick()

// $(document).ready(function(){
function slick_init() {
  console.log("slick_init 0")
  // if ($('.slick-slider').length ) {
    console.log("slick_init 1")
    // $('.slick-slider').not('.slick-initialized').slick({
    $('.slick-slider').slick({
      infinite: true,
      slidesToShow: 2,
      slidesToScroll: 1,
      dots: true,
      arrows: true,
      accessibility: true
    });
  // }
};

$('.slick-slider').on('click', function(){
  $(this).focus();
});


function toggler_init() {
  $("#show_history").click(function(){
      $("#versions_div").toggle(250);
      $("i", this).toggleClass("fa-angle-double-down fa-angle-double-up");
  });
  $("#show_programs").click(function(){
      $("#programs_div").toggle(250);
      $("i", this).toggleClass("fa-angle-double-down fa-angle-double-up");
  });
};

function tooltip_init() {
  $('[data-toggle="tooltip"]').tooltip()
}

// $(document).on('turbolinks:load', slick_init());

$(document).on('turbolinks:load', function() {
  console.log("-------- my_initializers::ready() -----------")
  slick_init();
  toggler_init();
  tooltip_init();
})