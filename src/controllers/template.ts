export default function template(fields: {body: string, title: string}) {
  return `
    <!DOCTYPE html>
    <html>
      <head>
        <title>${fields.title}</title>
        <link rel="stylesheet" href="/assets/index.css" />
      </head>
      
      <body>
        <div id="root">${fields.body}</div>
      </body>
      
      <script src="/assets/bundle.js"></script>
    </html>
  `;
};