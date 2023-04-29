SecureHeaders::Configuration.default do |config|
  config.csp = {
    default_src: %w('self'),
    script_src: %w('self' 'unsafe-inline' 'unsafe-eval'),
    style_src: %w('self' 'unsafe-inline'),
    img_src: %w('self' data:),
    connect_src: %w('self' http://localhost:3000),
    font_src: %w('self'),
    form_action: %w('self'),
    base_uri: %w('self'),
    frame_ancestors: %w('none'),
    block_all_mixed_content: true,
    upgrade_insecure_requests: true,
    report_uri: %w(/csp_report)
  }
end