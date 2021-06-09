import express from "express";
import * as fs from "fs";
import path from "path";

import * as errorController from "./controllers/errorController";
import * as homeController from "./controllers/homeController";
import * as playController from "./controllers/playController";

const app = express();
const publicPath = path.join(__dirname, "../public");
const assetsFilenames = fs.readdirSync(path.join(publicPath, "assets"));

// express setup
app.set("port", process.env.PORT || 3000);
app.set("views", path.join(__dirname, "../views"));
app.set("view engine", "ejs");
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(publicPath));

// routes
app.get("/", homeController.index(false));
app.get("/es", homeController.index(true));
app.get("/play", playController.index(assetsFilenames, false));
app.get("/juega", playController.index(assetsFilenames, true));
app.get("*", errorController.index);

// listen
app.listen(app.get("port"), () => {
  console.log(
    "  App is running at http://localhost:%d in %s mode",
    app.get("port"),
    app.get("env")
  );
  console.log("  Press CTRL-C to stop\n");
});
