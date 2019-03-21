import { Request, Response } from "express";

/**
 * GET /
 * Home page.
 */
export let index = (_: Request, res: Response) => {
  res.render("home",{
    title: "Emmanuel Suarez"
  })
};
