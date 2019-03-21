import { Request, Response } from "express";

/**
 * GET /
 * Error page.
 */
export let index = (_: Request, res: Response) => {
  res.render("error", {
    title: "Emmanuel Suarez"
  })
};