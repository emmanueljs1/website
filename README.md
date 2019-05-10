# Website

Hosted on www.emmanuelsuarez.com

## Overview
<i>src/</i>

OCaml source code for each view, compiled to Javascript into <i>app/public/javascripts</i> using Bucklescript.

<i>app/</i>
  
Express application in Typescript

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>app.ts</i>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Main application logic

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>controllers/</i>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Controllers for application routes

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>views/</i>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EJS template files for generating HTML with Express

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>public/</i>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Public assets

### Dependencies
- NPM

### How to run
First time:
```
> npm install; npm run build; npm start
```
Not first time:
```
> npm start
```
