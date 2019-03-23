import React from "react";

class Play extends React.Component {
  render() {
    const isMobile = this.props.isMobile;

    return (
      <html>
        <head>
          <title>{this.props.title}</title>
          <link rel="stylesheet" href="stylesheets/style.css"/>
          <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.0/css/all.css" integrity="sha384-Mmxa0mLqhmOeaE8vgOSbKacftZcsNYDjQzuCOm6D02luYSzBG8vpaOykv9lFQ51Y" crossOrigin="anonymous"/>
          <link rel="shortcut icon" type="image/x-icon" href="favicon.ico"/>
        </head>
        <body>
          <script src="javascripts/play.js"></script>
            {
              !isMobile ?
                <div>
                  <div className="house-container-play">
                    <div className="house-img house-margin"></div>
                  </div>
                  <canvas id="canvas"></canvas>
                </div>
              : 
                <div className="center-text">
                  <h1 className="mobile-h1">Try this out on a desktop!</h1>
                </div>
            }
        </body>
      </html>
    );
  }
}

export default Play;