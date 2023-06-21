$(function () {
  $("#post_image").on("change", function (event) {
    var files = event.target.files;
    var image = files[0];
    var reader = new FileReader();
    reader.onload = function (file) {
      $("#preview-image").attr("src",file.target.result);
    };
    reader.readAsDataURL(image);
  });
});
