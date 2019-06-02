import { Request, Response } from "express";

/**
 * GET /
 * Error page.
 */
export let index = (req: Request, res: Response) => {
  const MobileDetect = require("mobile-detect");
  const md = new MobileDetect(req.headers["user-agent"]);

  res.render("play", {
    title: "Emmanuel Suarez",
    isMobile: md.mobile() !== null
  });
};
