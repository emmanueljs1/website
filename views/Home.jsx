import React from 'react';

class Home extends React.Component {
  render() {
    const isMobile = this.props.isMobile;
    const isSpanish = this.props.isSpanish;
    const puertoRicoStr = isSpanish ? "Hecho en Puerto Rico" : "Born and raised in Puerto Rico";
    const puertoRicoBadge = !isMobile ? <a href="/es">&nbsp;<img className="puerto-rico" src="images/puerto-rico.png"></img></a> : null;
    const schoolStr = isSpanish ? "Estudiante en la Universidad de Pennsylvania" : "Senior at the University of Pennsylvania";
    const jobStr = isSpanish ? "Futuro ingeniero de software en Strava" : "Incoming Software Engineer at Strava";

    return (
      <html>
        <head>
          <title>{this.props.title}</title>
          <link rel="stylesheet" href="stylesheets/style.css"/>
          <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.0/css/all.css" integrity="sha384-Mmxa0mLqhmOeaE8vgOSbKacftZcsNYDjQzuCOm6D02luYSzBG8vpaOykv9lFQ51Y" crossOrigin="anonymous"/>
          <link rel="shortcut icon" type="image/x-icon" href="favicon.ico"/>
        </head>
        <body>
          <div>
          <div className="center-text">
            <h1 className={isMobile ? "mobile-h1" : "desktop-h1"}>Emmanuel Su&aacute;rez</h1>
            <h4>{puertoRicoStr}{puertoRicoBadge}</h4>
            <h4>{schoolStr}</h4>
            <h4>{jobStr}</h4>
          </div>
          <div className="row-center">
              <a href="https://www.linkedin.com/in/emsuac">
                { isMobile ? <i className="fab fa-linkedin fa-4x">&nbsp;</i> : <i className="fab fa-linkedin fa-2x">&nbsp;</i> }
              </a>
              <a href="https://www.github.com/emmanueljs1">
                { isMobile ? <i className="fab fa-github fa-4x">&nbsp;</i> : <i className="fab fa-github fa-2x">&nbsp;</i> }
              </a>
              <a href="mailto:emmanueljs1@gmail.com">
                { isMobile ? <i className="fas fa-envelope fa-4x">&nbsp;</i> : <i className="fas fa-envelope fa-2x">&nbsp;</i> }
              </a>
              <a href="files/resume.pdf">
                { isMobile ? <i className="fas fa-file-alt fa-4x">&nbsp;</i> : <i className="fas fa-file-alt fa-2x">&nbsp;</i> }
              </a>
          </div>
          {
            !isMobile ?
              <div className="house-container">
                <div className={isSpanish ? "house-img house-margin-es" : "house-img house-margin"}></div>
                <h4><a href="/play">{isSpanish ? "Presione para jugar" : "Click To Play"}</a></h4>
              </div>
            : null
          }
          </div>
        </body>
      </html>
    );
  }
}

export default Home;
