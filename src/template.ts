export default function template(fields: {body: string, title: string}) {
  return `
    <!DOCTYPE html>
    <html>
      <head>
        <title>${fields.title}</title>
        <link rel="stylesheet" href="stylesheets/style.css" />
      </head>

      <div class="sidenav">
        <a href="/">Home</a>
        <a href="about">About</a>
        <a href="projects">Projects</a>
      </div>

      <body>
        <div id="root">
          ${fields.body}
        </div>
      </body>
    </html>
  `;
}
