import cookieParser from "cookie-parser";
import errorHandler from "errorhandler";
import express from "express";
import logger from "morgan";
import path from "path";

import * as homeController from "./controllers/homeController";

const app = express();

// express setup
app.set("port", process.env.PORT || 3000);
app.set("views", path.join(__dirname, "../views"));
app.set("view engine", "ejs");
app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "../public")));
app.use(errorHandler());

// routes
app.use("/", homeController.index);

// listen
app.listen(app.get("port"), () => {
  console.log(
    "  App is running at http://localhost:%d in %s mode",
    app.get("port"),
    app.get("env")
  );
  console.log("  Press CTRL-C to stop\n");
});
