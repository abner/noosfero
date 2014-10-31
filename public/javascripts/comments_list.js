function load_comments(url) {
  jQuery.ajax({
    url: url,
    data: {"comment_order": 'oldest', "comment_list": true},
    success: function(response) {
      jQuery("#comments_list").html(response);
    },
  });
}

jQuery(document).ready(function($){
  $('#comments_list .lazy-comments').waypoint(function() {
    load_comments(jQuery("#page_url").val());
  }, {offset: 'bottom-in-view', triggerOnce: true});
});
