$(document).on('turbolinks:load', function() {
    $("body").on( "click", ".single-post-card, .single-post-list", function() {
      var posted_by = $(this).find('.post-content .posted-by').html();
      var post_heading = $(this).find('.post-content h3').html();
      var post_content = $(this).find('.post-content p').html();
      var interested = $(this).find('.post-content .interested').attr('href');
      $('.modal-header .posted-by').text(posted_by);
      $('.loaded-data h3').text(post_heading);
      $('.loaded-data p').text(post_content);
      $('.loaded-data .interested a').attr('href', interested);
      $('.myModal').modal('show');
    });
  });


window.addEventListener('turbo:before-cache', function (){
  var modal = document.querySelector('.myModal');
  if (modal){
      $(modal.modal('hide'));
  }
});