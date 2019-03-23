import React from "react";

class Play extends React.Component {
  render() {
    const isMobile = this.props.isMobile;

    return (
      <div>
        <head>
          <title>{this.props.title}</title>
          <link rel="stylesheet" href="stylesheets/style.css"/>
          <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.0/css/all.css" integrity="sha384-Mmxa0mLqhmOeaE8vgOSbKacftZcsNYDjQzuCOm6D02luYSzBG8vpaOykv9lFQ51Y" crossOrigin="anonymous"/>
          <link rel="shortcut icon" type="image/x-icon" href="favicon.ico"/>
        </head>
        <body className={isMobile ? "background" : "body"}>
          <script src="javascripts/play.js"></script>
          {
            !isMobile ?
              <div className="center-text">
                <h2>
                  Instructions
                </h2>
                <div>
                  <h4 style={{display: "inline-block"}}>
                    W - Move up
                  </h4>
                  &nbsp;&nbsp;
                  <h4 style={{display: "inline-block"}}>
                    A - Move left
                  </h4>
                </div>
                <div>
                  <h4 style={{display: "inline-block"}}>
                    S - Move down
                  </h4>
                  &nbsp;&nbsp;
                  <h4 style={{display: "inline-block"}}>
                    D - move right
                  </h4>
                </div>
                <h4>SPACE - Attack</h4>
                <canvas id="play-canvas" className="canvas background-play"></canvas>
              </div>
            : 
              <div className="center-text">
                <h1 className="mobile-h1">Try this out on a desktop!</h1>
              </div>
          }
        </body>
      </div>
    );
  }
}

export default Play;
