import React from "react";

class Error extends React.Component {
  render() {
    return (
      <html>
        <head>
            <title>{this.props.title}</title>
            <link rel="stylesheet" href="stylesheets/style.css" />
        </head>

        <body>
          <div class="center-text">
            <h1>Error: Page not found</h1>
          </div>
        </body>
      </html>
    );
  }
}

export default Error;
