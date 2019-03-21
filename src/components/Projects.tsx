import ReactDOM from 'react-dom/server';
import React from 'react';

class Projects extends React.Component {
  render() {
    return (
      <div>
        <h1><b>Projects</b></h1>
        <p>Coming soon, for now you can go <a href="https://www.github.com/emmanueljs1">here</a></p>
      </div>
    );
  }
}

export function renderToString() {
  return ReactDOM.renderToString(<Projects />);
};