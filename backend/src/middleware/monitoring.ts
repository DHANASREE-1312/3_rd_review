/**
 * Monitoring Middleware
 * Tracks HTTP requests, response times, and errors
 */

import monitoring from '../monitoring/appInsights';

/**
 * Request monitoring middleware
 * Tracks all incoming HTTP requests with timing and status
 */
export const requestMonitoringMiddleware = (req: any, res: any, next: any) => {
  const startTime = Date.now();
  const requestPath = req.path;
  const requestMethod = req.method;

  // Track request start
  console.log(`📥 ${requestMethod} ${requestPath} - Started`);

  // Capture original end function
  const originalEnd = res.end;

  // Override end function to capture response
  res.end = function(...args: any[]) {
    const duration = Date.now() - startTime;
    const statusCode = res.statusCode;
    const success = statusCode < 400;

    // Track the request
    monitoring.trackRequest(
      `${requestMethod} ${requestPath}`,
      req.originalUrl,
      duration,
      statusCode,
      success
    );

    // Track as metric
    monitoring.trackMetric('Request Duration', duration, {
      method: requestMethod,
      path: requestPath,
      statusCode
    });

    console.log(`📤 ${requestMethod} ${requestPath} - ${statusCode} (${duration}ms)`);

    // Call original end function
    originalEnd.apply(res, args);
  };

  next();
};

/**
 * Error monitoring middleware
 * Tracks all errors that occur during request processing
 */
export const errorMonitoringMiddleware = (err: any, req: any, res: any, next: any) => {
  // Track the error
  monitoring.trackError(
    err.message || 'Unknown error',
    err.name || 'Error',
    {
      path: req.path,
      method: req.method,
      statusCode: err.statusCode || 500,
      stack: err.stack
    }
  );

  // Track as event
  monitoring.trackEvent('RequestError', {
    path: req.path,
    method: req.method,
    errorMessage: err.message,
    errorType: err.name
  });

  next(err);
};

/**
 * Performance monitoring for specific operations
 */
export class PerformanceMonitor {
  private startTime: number;
  private operationName: string;

  constructor(operationName: string) {
    this.operationName = operationName;
    this.startTime = Date.now();
  }

  /**
   * End the performance monitoring and track the duration
   */
  end(success: boolean = true, additionalProperties?: any) {
    const duration = Date.now() - this.startTime;
    
    monitoring.trackMetric(
      `${this.operationName} Duration`,
      duration,
      { success, ...additionalProperties }
    );

    return duration;
  }
}

export default {
  requestMonitoringMiddleware,
  errorMonitoringMiddleware,
  PerformanceMonitor
};
