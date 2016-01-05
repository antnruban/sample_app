// Input's length checker on Home page.

window.onload = function() {
  var textarea = $('#micropost_content')[0];
  var div = $('div[class="field"]')[0];
  var submit = $('input[type="submit"][name="commit"]');
  var maxLength = 5;
  var errorClass = 'field_with_errors';
  var correctClass = 'field';

  textarea.onkeyup = function () {
    if (textarea.value.length > maxLength) {
      div.className = errorClass;
      submit.prop('disabled', true);
    }
    else {
      div.className = correctClass;
      submit.prop('disabled', false);
    }
  }
}
