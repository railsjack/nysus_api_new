//= require bootstrap-datetimepicker.min.js

$(document).ready(function(){
  console.log("making datetimepicker live");
  $(".datetimepicker").datetimepicker({
  	autoclose: true,
  	todayBtn: true,
  	showMeridian: true
  });
});