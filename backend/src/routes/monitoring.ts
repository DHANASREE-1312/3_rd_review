/**
 * Monitoring API Routes
 * Provides endpoints for metrics, health checks, and monitoring data
 */

const express = require('express');
const router = express.Router();
const monitoring = require('../monitoring/appInsights').default;

/**
 * GET /api/monitoring/metrics
 * Get current application metrics
 */
router.get('/metrics', (req: any, res: any) => {
  try {
    const metrics = monitoring.getMetrics();
    
    res.json({
      success: true,
      timestamp: new Date().toISOString(),
      metrics: {
        ...metrics,
        uptime: process.uptime(),
        memoryUsage: process.memoryUsage(),
        cpuUsage: process.cpuUsage()
      }
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

/**
 * GET /api/monitoring/health
 * Enhanced health check with detailed status
 */
router.get('/health', (req: any, res: any) => {
  const healthStatus = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    monitoring: monitoring.isMonitoringEnabled() ? 'enabled' : 'disabled',
    environment: process.env.NODE_ENV || 'development',
    version: '1.0.0'
  };

  res.json(healthStatus);
});

/**
 * POST /api/monitoring/event
 * Track custom event (for testing)
 */
router.post('/event', (req: any, res: any) => {
  try {
    const { name, properties, measurements } = req.body;
    
    if (!name) {
      return res.status(400).json({
        success: false,
        error: 'Event name is required'
      });
    }

    monitoring.trackEvent(name, properties, measurements);

    res.json({
      success: true,
      message: 'Event tracked successfully',
      event: { name, properties, measurements }
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

/**
 * POST /api/monitoring/metric
 * Track custom metric (for testing)
 */
router.post('/metric', (req: any, res: any) => {
  try {
    const { name, value, properties } = req.body;
    
    if (!name || value === undefined) {
      return res.status(400).json({
        success: false,
        error: 'Metric name and value are required'
      });
    }

    monitoring.trackMetric(name, value, properties);

    res.json({
      success: true,
      message: 'Metric tracked successfully',
      metric: { name, value, properties }
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

/**
 * GET /api/monitoring/status
 * Get monitoring system status
 */
router.get('/status', (req: any, res: any) => {
  res.json({
    monitoring: {
      enabled: monitoring.isMonitoringEnabled(),
      provider: 'Azure Application Insights',
      features: [
        'Request tracking',
        'Performance monitoring',
        'Error tracking',
        'Custom events',
        'Custom metrics',
        'Dependency tracking'
      ]
    },
    metrics: monitoring.getMetrics()
  });
});

export default router;
