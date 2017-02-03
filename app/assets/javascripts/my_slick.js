// $(".slick-slider").not('.slick-initialized').slick()

// $(document).ready(function(){
function slick_init() {
  console.log("slick_init 0")
  if ($('.slick-slider').length ) {
    console.log("slick_init 1")
    $('.slick-slider').not('.slick-initialized').slick({
      infinite: true,
      slidesToShow: 2,
      slidesToScroll: 1,
      dots: true,
      arrows: true,
      accessibility: true
    });
  }
};

$('.slick-slider').on('click', function(){
  $(this).focus();
});

$(document).on('turbolinks:load', slick_init());
