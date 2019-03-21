import { Request, Response } from "express";
import template from '../template';
import * as Projects from '../components/Projects'; 

/**
 * GET /
 * Home page.
 */
export let index = (_: Request, res: Response) => {
  res.send(template({
    body: Projects.renderToString(),
    title: "Emmanuel Suarez"
  }));
};