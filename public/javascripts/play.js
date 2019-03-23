window.onload = function() {
  let canvas = document.getElementById("play-canvas");
  let ctx = canvas.getContext("2d");
  let grassHeight = 70;
  let leftBound = 5;
  ctx.fillStyle = "#FF0000";
  ctx.fillRect(leftBound, grassHeight, 10, 10);
}