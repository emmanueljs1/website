import ReactDOM from "react-dom/server";
import React from "react";

class About extends React.Component {
  render() {
    return (
      <div>
        <h1>About Me</h1>
        <p>
          Hi there! I am a senior at the University of Pennsylvania studying computer science, and
          this upcoming fall I will be a software engineer at Strava.
        </p>
      </div>
    );
  }
}

export function renderToString() {
  return ReactDOM.renderToString(<About />);
}
