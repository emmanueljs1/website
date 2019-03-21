import { Request, Response } from "express";
import template from './template';
import * as Home from '../components/home/Home'; 

/**
 * GET /
 * Home page.
 */
export let index = (_: Request, res: Response) => {
  res.send(template({
    body: Home.renderToString(),
    title: "Home"
  }));
};
