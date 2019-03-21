import { Request, Response } from "express";
import template from '../template';
import * as Error from '../components/Error'; 

/**
 * GET /
 * Home page.
 */
export let index = (_: Request, res: Response) => {
  res.send(template({
    body: Error.renderToString(),
    title: "Emmanuel Suarez"
  }));
};