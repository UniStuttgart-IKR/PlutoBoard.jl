import { insertHTMLToBody } from './loadHTML.js';
import { resizePlutoNav, updateAllCells } from './internal.js';
import { setIFrames } from './iFrame.js';

// --------------------------------------------------- LOAD HTML ---------------------------------------------------
await insertHTMLToBody();

resizePlutoNav();
setIFrames();

// --------------------------------------------------- GENERAL ---------------------------------------------------





