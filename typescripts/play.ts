window.onload = function() {
  const canvas = <HTMLCanvasElement> document.getElementById("play-canvas");
  const ctx = canvas.getContext("2d");
  const grassHeight = 70;
  const leftBound = 5;
  ctx.fillStyle = "#FF0000";
  ctx.fillRect(leftBound, grassHeight, 10, 10);
};
