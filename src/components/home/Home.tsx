import ReactDOM from 'react-dom/server';
import React from 'react';

class Home extends React.Component {
  render() {
    return (
      <div>
        Hello
      </div>
    );
  }
}

export function renderToString() {
  return ReactDOM.renderToString(<Home />);
};