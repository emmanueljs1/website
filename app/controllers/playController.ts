import { Request, Response } from "express";
import * as fs from "fs";
import path from "path";

/**
 * GET /
 * Error page.
 */
export function index(publicPath: string, isSpanish: boolean) {
  return (req: Request, res: Response) => {
    const MobileDetect = require("mobile-detect");
    const md = new MobileDetect(req.headers["user-agent"]);
    const assetsFilenames = fs.readdirSync(path.join(publicPath, "assets"));

     res.render("play", {
       title: "Emmanuel Suárez Acevedo",
       isMobile: md.mobile() !== null,
       isSpanish: isSpanish,
       assetsFilenames: assetsFilenames
     });
  };
}
