import React from "react";

interface ErrorProps { title: string }

class Error extends React.Component<ErrorProps, {}> {
  render() {
    return (
      <html>
        <head>
            <title>{this.props.title}</title>
            <link rel="stylesheet" href="stylesheets/style.css" />
        </head>

        <body>
          <div className="center-text">
            <h1>Error: Page not found</h1>
          </div>
        </body>
      </html>
    );
  }
}

export default Error;
