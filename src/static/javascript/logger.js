
/**
 * @fileoverview Logging utilities for PlutoBoard.jl
 * @module Logger
 */

/**
 * Logs an informational message to the console with the PlutoBoard.jl prefix
 * @memberof module:Logger
 * @param {string} message The message to be logged
 * @returns {void}
 */
export function info(message) {
    console.log(`[PlutoBoard.jl] ${message}`);
}

/**
 * Logs a warning message to the console with the PlutoBoard.jl prefix
 * @memberof module:Logger
 * @param {string} message The warning message to be logged
 * @returns {void}
 */
export function warn(message) {
    console.warn(`[PlutoBoard.jl] ${message}`);
}

/**
 * Logs an error message to the console with the PlutoBoard.jl prefix
 * @memberof module:Logger
 * @param {string} message The error message to be logged
 * @returns {void}
 */
export function error(message) {
    console.error(`[PlutoBoard.jl] ${message}`);
}