import { Request, Response } from "express";
import template from "../template";
import * as About from "../components/About";

/**
 * GET /
 * About page.
 */
export let index = (_: Request, res: Response) => {
  res.send(template({
    body: About.renderToString(),
    title: "Emmanuel Suarez"
  }));
};