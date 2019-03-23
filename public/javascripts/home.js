function isHover(e) {
  return (e.parentElement.querySelector(':hover') === e);
}

function changeColor() {
  var clickToPlay = document.getElementById("click-to-play");
  if (!isHover(clickToPlay)) {
    if (clickToPlay.style.color == "white") {
      clickToPlay.style.color = "#595959";
    }
    else {
      clickToPlay.style.color = "white";
    }
  }
  else {
    clickToPlay.style.color = "white";
  }
}

window.setInterval(changeColor, 250);
