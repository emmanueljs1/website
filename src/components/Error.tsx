import ReactDOM from 'react-dom/server';
import React from 'react';

class Error extends React.Component {
  render() {
    return (
      <div>
        Page not found.
      </div>
    );
  }
}

export function renderToString() {
  return ReactDOM.renderToString(<Error />);
};