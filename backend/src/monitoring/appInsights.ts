/**
 * Azure Application Insights Monitoring Configuration
 * Provides real-time monitoring, metrics, and alerting capabilities
 */

const appInsights = require('applicationinsights');

// Monitoring metrics interface
interface MonitoringMetrics {
  requestCount: number;
  errorCount: number;
  feedbackSubmissions: number;
  aiAnalysisCount: number;
  avgResponseTime: number;
}

class ApplicationInsightsMonitoring {
  private client: any;
  private isEnabled: boolean = false;
  private metrics: MonitoringMetrics = {
    requestCount: 0,
    errorCount: 0,
    feedbackSubmissions: 0,
    aiAnalysisCount: 0,
    avgResponseTime: 0
  };

  constructor() {
    const connectionString = process.env.APPLICATIONINSIGHTS_CONNECTION_STRING;
    
    if (connectionString) {
      try {
        // Setup Application Insights
        appInsights.setup(connectionString)
          .setAutoDependencyCorrelation(true)
          .setAutoCollectRequests(true)
          .setAutoCollectPerformance(true, true)
          .setAutoCollectExceptions(true)
          .setAutoCollectDependencies(true)
          .setAutoCollectConsole(true, true)
          .setUseDiskRetryCaching(true)
          .setSendLiveMetrics(true)
          .setDistributedTracingMode(appInsights.DistributedTracingModes.AI_AND_W3C)
          .start();

        this.client = appInsights.defaultClient;
        this.isEnabled = true;
        
        console.log('✅ Application Insights monitoring enabled');
        
        // Set custom properties
        this.client.context.tags[this.client.context.keys.cloudRole] = 'mess-feedback-backend';
        this.client.context.tags[this.client.context.keys.cloudRoleInstance] = process.env.WEBSITE_INSTANCE_ID || 'local';
        
      } catch (error) {
        console.error('❌ Failed to initialize Application Insights:', error);
        this.isEnabled = false;
      }
    } else {
      console.log('⚠️ Application Insights not configured (APPLICATIONINSIGHTS_CONNECTION_STRING not set)');
      console.log('💡 Monitoring will use console logging only');
    }
  }

  /**
   * Track custom event
   */
  trackEvent(name: string, properties?: any, measurements?: any) {
    if (this.isEnabled && this.client) {
      this.client.trackEvent({
        name,
        properties,
        measurements
      });
    }
    console.log(`📊 Event: ${name}`, properties);
  }

  /**
   * Track custom metric
   */
  trackMetric(name: string, value: number, properties?: any) {
    if (this.isEnabled && this.client) {
      this.client.trackMetric({
        name,
        value,
        properties
      });
    }
    console.log(`📈 Metric: ${name} = ${value}`);
  }

  /**
   * Track exception/error
   */
  trackException(error: Error, properties?: any) {
    if (this.isEnabled && this.client) {
      this.client.trackException({
        exception: error,
        properties
      });
    }
    console.error(`❌ Exception tracked:`, error.message, properties);
  }

  /**
   * Track dependency (external calls)
   */
  trackDependency(name: string, data: string, duration: number, success: boolean, dependencyType?: string) {
    if (this.isEnabled && this.client) {
      this.client.trackDependency({
        name,
        data,
        duration,
        success,
        dependencyTypeName: dependencyType || 'HTTP'
      });
    }
  }

  /**
   * Track HTTP request
   */
  trackRequest(name: string, url: string, duration: number, responseCode: number, success: boolean) {
    this.metrics.requestCount++;
    
    if (this.isEnabled && this.client) {
      this.client.trackRequest({
        name,
        url,
        duration,
        resultCode: responseCode,
        success
      });
    }
  }

  /**
   * Track feedback submission
   */
  trackFeedbackSubmission(userId: string, mealType: string, rating: number, hasAIAnalysis: boolean) {
    this.metrics.feedbackSubmissions++;
    
    this.trackEvent('FeedbackSubmitted', {
      userId,
      mealType,
      rating,
      hasAIAnalysis
    }, {
      rating
    });
  }

  /**
   * Track AI analysis
   */
  trackAIAnalysis(feedbackId: string, sentiment: string, priority: number, duration: number) {
    this.metrics.aiAnalysisCount++;
    
    this.trackEvent('AIAnalysisCompleted', {
      feedbackId,
      sentiment,
      priority
    }, {
      priority,
      duration
    });
  }

  /**
   * Track database query performance
   */
  trackDatabaseQuery(queryName: string, duration: number, success: boolean) {
    this.trackDependency(
      queryName,
      'Azure SQL Database',
      duration,
      success,
      'SQL'
    );
  }

  /**
   * Track error
   */
  trackError(errorMessage: string, errorType: string, properties?: any) {
    this.metrics.errorCount++;
    
    const error = new Error(errorMessage);
    error.name = errorType;
    
    this.trackException(error, properties);
  }

  /**
   * Get current metrics
   */
  getMetrics(): MonitoringMetrics {
    return { ...this.metrics };
  }

  /**
   * Reset metrics
   */
  resetMetrics() {
    this.metrics = {
      requestCount: 0,
      errorCount: 0,
      feedbackSubmissions: 0,
      aiAnalysisCount: 0,
      avgResponseTime: 0
    };
  }

  /**
   * Flush all telemetry
   */
  flush() {
    if (this.isEnabled && this.client) {
      this.client.flush();
    }
  }

  /**
   * Check if monitoring is enabled
   */
  isMonitoringEnabled(): boolean {
    return this.isEnabled;
  }
}

// Export singleton instance
const monitoring = new ApplicationInsightsMonitoring();
export default monitoring;
