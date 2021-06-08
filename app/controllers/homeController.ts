import { Request, Response } from "express";

/**
 * GET /
 * Home page.
 */
export function index(isSpanish: boolean) {
  return (req: Request, res: Response) => {
    const MobileDetect = require("mobile-detect");
    const md = new MobileDetect(req.headers["user-agent"]);

    res.render("home", {
      title: "Emmanuel Suárez Acevedo",
      isSpanish: isSpanish,
      isMobile: md.mobile() !== null
    });
  };
}
