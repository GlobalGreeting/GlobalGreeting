$(function () {
  $("#chinese").on("click", function(){
    $('#result').html('你好');
    $('#choice').html('Chinese');
  });
  $("#spanish").on("click", function(){
    $('#result').html('Buenos Dias');
    $('#choice').html('Spanish');
  });
  $("#greek").on("click", function(){
    $('#result').html('Χαίρετε');
    $('#choice').html('Greek');
  });  
});
