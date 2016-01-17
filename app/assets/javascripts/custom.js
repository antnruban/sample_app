// Input's length checker on Home page.
(function($) {
  $(document).ready(function() {
    var $textarea = $('#micropost_content');
    var $div = $('div[class="field"]');
    var $submit = $('input[type="submit"][name="commit"]');
    var maxLength = 140;
    var errorClass = 'field_with_errors';

    $textarea.on('keyup', function() {
      if ($(this).val().length > maxLength) {
        $div.addClass(errorClass);
        $submit.prop('disabled', true);
      }
      else {
        $div.removeClass(errorClass);
        $submit.prop('disabled', false);
      }
    });
  });
})(jQuery);
