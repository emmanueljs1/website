import ReactDOM from 'react-dom/server';
import React from 'react';

class Home extends React.Component {
  render() {
    return (
      <div>
        <h1><b>Emmanuel Suarez</b></h1>
        <p>Website under construction!</p>
      </div>
    );
  }
}

export function renderToString() {
  return ReactDOM.renderToString(<Home />);
};